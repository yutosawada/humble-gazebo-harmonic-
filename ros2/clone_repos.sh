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

awk_cmd='match($0,/- name:/){name=$3}
    /^\s*repo:/ {repo=$2}
    /^\s*branch:/ {branch=$2}
    /^\s*commit:/ {commit=$2; print name "|" repo "|" branch "|" commit}'

while IFS='|' read -r NAME REPO BRANCH COMMIT; do
  [ -z "$NAME" ] && continue
  TARGET="$SRC_DIR/$NAME"
  echo "==== Processing $NAME ===="
  if [ ! -d "$TARGET" ]; then
    echo "Cloning $REPO into $TARGET"
    git clone "$REPO" "$TARGET"
  else
    echo "Directory $TARGET already exists, skipping clone"
  fi
  cd "$TARGET"
  echo "Checking out branch $BRANCH"
  git fetch origin "$BRANCH"
  git checkout "$BRANCH"
  echo "Resetting to commit $COMMIT"
  git reset --hard "$COMMIT"
  cd "$BASE_DIR"
  echo ""
done < <(grep -v '^repositories:' "$YAML_FILE" | awk "$awk_cmd")
