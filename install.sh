#!/usr/bin/env bash
# Copy this framework's .claude/ directory into a target directory.
# Existing files are never overwritten; each skipped file is printed.
#
# Usage:
#   ./install.sh <target-dir>          # e.g. ./install.sh ~/my-project  -> ~/my-project/.claude/
#   ./install.sh --global              # installs into ~/.claude/
#   ./install.sh <target-dir> --dry-run
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.claude"
DRY_RUN=0
TARGET=""

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --global)  TARGET="$HOME" ;;
    -h|--help)
      sed -n '2,9p' "$0"; exit 0 ;;
    *) TARGET="$arg" ;;
  esac
done

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target-dir> [--dry-run] | --global [--dry-run]" >&2
  exit 1
fi
if [ ! -d "$SRC_DIR" ]; then
  echo "Source directory not found: $SRC_DIR" >&2
  exit 1
fi
if [ ! -d "$TARGET" ]; then
  echo "Target directory does not exist: $TARGET" >&2
  exit 1
fi

DEST_DIR="$(cd "$TARGET" && pwd)/.claude"
copied=0
skipped=0

echo "Installing from $SRC_DIR"
echo "            to $DEST_DIR"
[ "$DRY_RUN" -eq 1 ] && echo "(dry run: nothing will be written)"
echo

while IFS= read -r -d '' file; do
  rel="${file#"$SRC_DIR"/}"
  dest="$DEST_DIR/$rel"
  if [ -e "$dest" ]; then
    echo "skip   $rel (already exists)"
    skipped=$((skipped + 1))
    continue
  fi
  echo "copy   $rel"
  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$(dirname "$dest")"
    cp -p "$file" "$dest"
  fi
  copied=$((copied + 1))
done < <(find "$SRC_DIR" -type f ! -name '.DS_Store' ! -name 'settings.local.json' -print0 | sort -z)

echo
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete: $copied would be copied, $skipped skipped."
else
  echo "Done: $copied copied, $skipped skipped."
fi
