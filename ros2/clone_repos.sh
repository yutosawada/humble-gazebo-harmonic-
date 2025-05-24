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


awk_cmd='
function print_repo() {
  if (name != "") {
    print name "|" repo "|" branch "|" commit
  }
}
/^\s*- name:/ {
  print_repo();
  name=$0; sub(/.*- name:[ ]*/, "", name);
  repo=""; branch=""; commit="";
  next;
}
/^\s*repo:/ { repo=$0; sub(/.*repo:[ ]*/, "", repo); next; }
/^\s*branch:/ { branch=$0; sub(/.*branch:[ ]*/, "", branch); next; }
/^\s*commit:/ { commit=$0; sub(/.*commit:[ ]*/, "", commit); next; }
END { print_repo() }'


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
  if [ -n "$BRANCH" ]; then
    echo "Checking out branch $BRANCH"
    git fetch origin "$BRANCH"
    git checkout "$BRANCH"
  else
    echo "Using default branch"
  fi
  if [ -n "$COMMIT" ]; then
    echo "Resetting to commit $COMMIT"
    git fetch --all
    git reset --hard "$COMMIT"
  fi

  cd "$BASE_DIR"
  echo ""
done < <(grep -v '^repositories:' "$YAML_FILE" | awk "$awk_cmd")
