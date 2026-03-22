---
name: claude-mem-timeline-report
description: Use when asked for a project history, journey report, development timeline, or narrative analysis built from claude-mem observations across many sessions.
---

# Claude-Mem Timeline Report For Codex

Generate a narrative report from claude-mem history using shell tools plus Codex subagents when the corpus is large.

## Prerequisites

Prefer the worker API on `http://localhost:37777`. Fall back to `~/.claude-mem/claude-mem.db` only if the worker is unavailable.

## Step 1: Resolve The Project Name

If the user says "this project", use the current repo name. In a git worktree, use the parent repo name:

```bash
git_dir=$(git rev-parse --git-dir 2>/dev/null)
git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
if [ "$git_dir" != "$git_common_dir" ]; then
  basename "$(dirname "$git_common_dir")"
else
  basename "$PWD"
fi
```

Tell the user when a worktree changed the project name.

## Step 2: Fetch The Timeline

Health check:

```bash
curl -sf http://localhost:37777/health
```

Full timeline:

```bash
curl -s "http://localhost:37777/api/context/inject?project=PROJECT_NAME&full=true"
```

Save large timelines to a temp file before analysis.

## Step 3: Estimate Size Before Analysis

Estimate input size from bytes:

```bash
bytes=$(wc -c < timeline.txt)
tokens=$(( bytes / 4 ))
printf "bytes=%s tokens~=%s\n" "$bytes" "$tokens"
```

If the estimate exceeds roughly 100000 tokens, warn the user before continuing. For very large histories, analyze in chronological chunks instead of one pass.

## Step 4: Analyze Chronologically

Write the report yourself in this session. If the timeline is too large for one pass:
- split by month or major date windows
- summarize each chunk first
- merge chunk summaries into the final narrative

## Codex Subagent Pattern

For medium or large timelines:
- fetch the raw timeline locally
- split it into bounded chronological chunks
- send each chunk to a `worker` or default subagent with one analysis objective
- keep final synthesis and consistency checking local

Good parallel decomposition:
- one agent for project genesis and early architecture
- one agent for middle-period refactors and debugging cycles
- one agent for recent stabilization and ongoing themes
- one agent for ROI/statistics based on SQL query output

Do not wait for all agents immediately if you can continue preparing statistics or drafting the report skeleton locally.

Cover at least:
- project genesis
- architectural evolution
- key breakthroughs
- work patterns
- technical debt
- debugging sagas
- memory and continuity
- timeline statistics
- lessons and meta-observations

## Step 5: Quantify ROI When Possible

If `sqlite3` is available and the database exists, compute supporting metrics:

```bash
sqlite3 ~/.claude-mem/claude-mem.db "
SELECT SUM(discovery_tokens) FROM observations WHERE project = 'PROJECT_NAME';
"
```

```bash
sqlite3 ~/.claude-mem/claude-mem.db "
SELECT id, title, discovery_tokens
FROM observations
WHERE project = 'PROJECT_NAME'
ORDER BY discovery_tokens DESC
LIMIT 5;
"
```

Use quantitative sections only when the data is actually available.

## Output Rules

- Cite observation IDs or dates for major claims.
- Separate facts from interpretation.
- Be honest about missing or sparse history.
- Save the report to a markdown file if the user asked for an artifact.

## Failure Modes To Prevent

- analyzing only the recent tail of the timeline
- ignoring project-name mismatches in worktrees
- treating incomplete metrics as precise ROI
- trying to force a single-pass analysis when the timeline is too large
- sending the full unbounded timeline to one agent when chunking would be more reliable
