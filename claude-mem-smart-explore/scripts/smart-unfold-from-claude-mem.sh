#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <claude-mem-repo> <file_path> <symbol_name>" >&2
  exit 1
fi

REPO_PATH=$1
FILE_PATH=$2
SYMBOL_NAME=$3

cd "$REPO_PATH"

FILE_PATH="$FILE_PATH" SYMBOL_NAME="$SYMBOL_NAME" \
  npx tsx --eval '
    import { readFile } from "node:fs/promises";
    import { unfoldSymbol } from "./src/services/smart-file-read/parser.ts";
    const filePath = process.env.FILE_PATH;
    const symbolName = process.env.SYMBOL_NAME;
    if (!filePath || !symbolName) throw new Error("FILE_PATH and SYMBOL_NAME are required");
    const content = await readFile(filePath, "utf-8");
    const unfolded = unfoldSymbol(content, filePath, symbolName);
    if (!unfolded) {
      console.error(`Symbol not found: ${symbolName}`);
      process.exit(2);
    }
    console.log(unfolded);
  '
