#!/usr/bin/env bash
TARGET="${1:?Usage: $0 <path>}"
if [[ -d "$TARGET" ]]; then
echo "$TARGET is a directory"
elif [[ -f "$TARGET" ]]; then
echo "$TARGET is a file"
else
echo "$TARGET not found" >&2
exit 2
fi
