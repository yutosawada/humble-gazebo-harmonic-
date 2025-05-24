#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
YAML_FILE="$BASE_DIR/repos.yaml"
SRC_DIR="$BASE_DIR/ros2_ws/src"

if [ ! -f "$YAML_FILE" ]; then
  echo "Error: $YAML_FILE not found." >&2
  exit 1
fi

mkdir -p "$SRC_DIR"

echo "=== リポジトリクローンを開始します ==="
echo "YAMLファイル: $YAML_FILE"
echo "出力先ディレクトリ: $SRC_DIR"

# YAMLパーサー
awk_cmd='
BEGIN { in_repo = 0; }
/^repositories:/ { in_repo = 1; next; }
/^  - name:/ && in_repo {
  name = $0; sub(/.*- name:[ ]*/, "", name);
  getline; repo = $0; sub(/.*repo:[ ]*/, "", repo);
  getline; branch = $0; sub(/.*branch:[ ]*/, "", branch);
  getline; commit = $0; sub(/.*commit:[ ]*/, "", commit);
  # 空白を取り除く
  gsub(/^[ \t]+|[ \t]+$/, "", name);
  gsub(/^[ \t]+|[ \t]+$/, "", repo);
  gsub(/^[ \t]+|[ \t]+$/, "", branch);
  gsub(/^[ \t]+|[ \t]+$/, "", commit);
  print name "|" repo "|" branch "|" commit;
}'


while IFS='|' read -r NAME REPO BRANCH COMMIT; do
  [ -z "$NAME" ] && continue
  TARGET="$SRC_DIR/$NAME"
  echo "==== リポジトリ処理: $NAME ===="
  if [ ! -d "$TARGET" ]; then
    echo "クローン中: $REPO -> $TARGET"
    if ! git clone "$REPO" "$TARGET"; then
      echo "警告: $REPO のクローンに失敗しました。スキップします。"
      continue
    fi
  else
    echo "既存のディレクトリ: $TARGET (クローンをスキップ)"
  fi
  cd "$TARGET"
  if [ -n "$BRANCH" ]; then
    echo "ブランチ $BRANCH をチェックアウト"
    if ! git fetch origin "$BRANCH" 2>/dev/null; then
      echo "警告: ブランチ $BRANCH が見つかりません。デフォルトブランチを使用します。"
    else
      git checkout "$BRANCH"
    fi
  else
    echo "デフォルトブランチを使用"
  fi
  if [ -n "$COMMIT" ]; then
    echo "コミット $COMMIT にリセット"
    if ! git fetch --all && git reset --hard "$COMMIT"; then
      echo "警告: コミット $COMMIT へのリセットに失敗しました。"
    fi
  fi

  cd "$BASE_DIR"
  echo ""
done < <(awk "$awk_cmd" "$YAML_FILE")

echo "=== リポジトリクローン完了 ==="
