---
name: claude-mem-memory-search
description: Use when a user asks what happened in previous sessions, whether a bug was solved before, how an older implementation worked, or anything else that should be answered from claude-mem history instead of the current chat.
---

# Claude-Mem Memory Search For Codex

Codex does not have Claude's `search`, `timeline`, or `get_observations` MCP tools. Replace them with the local claude-mem HTTP API when available, and fall back to SQLite when it is not.

If the user explicitly wants subagent help, delegate only the summarization or categorization step after retrieval. Keep the actual data access local so the critical path stays short.

## Prerequisites

Use this skill only if at least one data source exists:
- worker API on `http://localhost:37777`
- database at `~/.claude-mem/claude-mem.db`

Check the worker first:

```bash
curl -sf http://localhost:37777/health
```

## Required Workflow

Always follow `search -> filter -> fetch`. Do not dump full observations first.

### Step 1: Search The Index

Use the worker API:

```bash
curl -s "http://localhost:37777/api/search?query=authentication&limit=20&project=my-project"
```

If `jq` is available, summarize the index instead of pasting raw JSON:

```bash
curl -s "http://localhost:37777/api/search?query=authentication&limit=20&project=my-project" \
| jq '.observations[] | {id, title, type, created_at}'
```

Useful filters:
- `type=observations|sessions|prompts`
- `obs_type=bugfix,feature,decision,discovery,refactor`
- `dateStart=YYYY-MM-DD`
- `dateEnd=YYYY-MM-DD`
- `limit=20`

### Step 2: Pull Timeline Context Around A Candidate

```bash
curl -s "http://localhost:37777/api/timeline?anchor=11131&depth_before=3&depth_after=3&project=my-project"
```

Or query for the anchor:

```bash
curl -s "http://localhost:37777/api/timeline?query=authentication&depth_before=3&depth_after=3&project=my-project"
```

Use this step to discard irrelevant IDs before fetching details.

### Step 3: Fetch Only The Kept Observations

Single observation:

```bash
curl -s "http://localhost:37777/api/observation/11131"
```

Batch fetch:

```bash
curl -s -X POST "http://localhost:37777/api/observations/batch" \
  -H "Content-Type: application/json" \
  -d '{"ids":[11131,10942],"orderBy":"date_desc","project":"my-project"}'
```

Prefer the batch endpoint for 2 or more IDs.

## Codex Subagent Pattern

Only use subagents after you already have the candidate observations.

Good delegation:
- one agent summarizes bug-fix observations
- one agent summarizes architecture or decision observations
- one agent compares two time windows

Keep these local:
- worker health check
- API calls and SQL queries
- final answer assembly when the fetched set is small

Do not spawn an agent just to run one `curl` or `sqlite3` command.

## SQLite Fallback

If the worker is down but the database exists, use `sqlite3` for rough recall:

```bash
sqlite3 ~/.claude-mem/claude-mem.db "
SELECT id, created_at, type, title
FROM observations
WHERE project = 'my-project'
  AND (title LIKE '%authentication%' OR narrative LIKE '%authentication%' OR facts LIKE '%authentication%')
ORDER BY created_at_epoch DESC
LIMIT 20;
"
```

Then fetch exact rows:

```bash
sqlite3 ~/.claude-mem/claude-mem.db "
SELECT id, title, subtitle, narrative, facts, concepts, files_modified
FROM observations
WHERE id IN (11131,10942);
"
```

SQLite fallback is less accurate than the worker's semantic search. Say so when using it.

## Response Discipline

- State whether the answer came from the worker API or SQLite fallback.
- Include observation IDs or timestamps when summarizing prior work.
- Distinguish verified recall from inference.
- If nothing relevant is found, say that directly.
