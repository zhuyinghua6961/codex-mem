---
name: claude-mem-data-inspection
description: Use when the task needs raw claude-mem records, pagination over observations or prompts, exact fetches by ID, citation support, project inventory, or worker and database counts instead of narrative recall.
---

# Claude-Mem Data Inspection For Codex

Use this skill for raw records and metadata, not search strategy. It is the direct-inspection companion to `claude-mem-memory-search` and `claude-mem-advanced-search`.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

## Paginated Lists

```bash
curl -s "http://localhost:37777/api/observations?offset=0&limit=20&project=my-project"
curl -s "http://localhost:37777/api/summaries?offset=0&limit=20&project=my-project"
curl -s "http://localhost:37777/api/prompts?offset=0&limit=20&project=my-project"
```

## Exact Fetches

```bash
curl -s "http://localhost:37777/api/observation/11131"
curl -s "http://localhost:37777/api/session/42"
curl -s "http://localhost:37777/api/prompt/88"
```

Batch fetch:

```bash
curl -s -X POST "http://localhost:37777/api/observations/batch" \
  -H "Content-Type: application/json" \
  -d '{"ids":[11131,10942],"project":"my-project"}'
```

SDK sessions by memory session IDs:

```bash
curl -s -X POST "http://localhost:37777/api/sdk-sessions/batch" \
  -H "Content-Type: application/json" \
  -d '{"memorySessionIds":["session-a","session-b"]}'
```

## Stats And Projects

```bash
curl -s "http://localhost:37777/api/stats"
curl -s "http://localhost:37777/api/projects"
```

Use these to answer:
- how many observations exist
- which projects are known
- where the database lives
- whether the worker has active sessions or SSE clients

## Citation Workflow

- Search first with a recall skill.
- Keep the winning IDs.
- Fetch exact records here.
- Cite the observation IDs or timestamps in the final answer.

## Codex Subagent Pattern

This skill is mostly local. Delegate only when a large fetched set needs categorization or comparison.

## Common Mistakes

- Using paginated lists as a substitute for search
- Quoting counts without saying whether they came from `/api/stats` or fetched lists
- Forgetting to preserve IDs needed for citations
