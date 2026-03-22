#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <claude-mem-repo> <query> [path] [max_results] [file_pattern]" >&2
  exit 1
fi

REPO_PATH=$1
QUERY=$2
SEARCH_PATH=${3:-.}
MAX_RESULTS=${4:-20}
FILE_PATTERN=${5:-}

cd "$REPO_PATH"

QUERY="$QUERY" SEARCH_PATH="$SEARCH_PATH" MAX_RESULTS="$MAX_RESULTS" FILE_PATTERN="$FILE_PATTERN" \
  npx tsx --eval '
    import { searchCodebase, formatSearchResults } from "./src/services/smart-file-read/search.ts";
    const query = process.env.QUERY || "";
    const searchPath = process.env.SEARCH_PATH || ".";
    const maxResults = Number(process.env.MAX_RESULTS || 20);
    const filePattern = process.env.FILE_PATTERN || undefined;
    const result = await searchCodebase(searchPath, query, { maxResults, filePattern });
    console.log(formatSearchResults(result, query));
  '
