#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <claude-mem-repo> <file_path>" >&2
  exit 1
fi

REPO_PATH=$1
FILE_PATH=$2

cd "$REPO_PATH"

FILE_PATH="$FILE_PATH" \
  npx tsx --eval '
    import { readFile } from "node:fs/promises";
    import { parseFile, formatFoldedView } from "./src/services/smart-file-read/parser.ts";
    const filePath = process.env.FILE_PATH;
    if (!filePath) throw new Error("FILE_PATH is required");
    const content = await readFile(filePath, "utf-8");
    const parsed = parseFile(content, filePath);
    console.log(formatFoldedView(parsed));
  '
