---
name: claude-mem-advanced-search
description: Use when claude-mem history needs more than the default recall workflow, including finding decisions, changes, how-it-works explanations, sessions, prompts, or exact matches by concept, file, or observation type.
---

# Claude-Mem Advanced Search For Codex

Use this when `claude-mem-memory-search` is too narrow. Keep retrieval local with HTTP calls, then delegate summarization only if the result set is large.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

## Search Modes

Unified search:

```bash
curl -s "http://localhost:37777/api/search?query=authentication&limit=20&project=my-project"
curl -s "http://localhost:37777/api/search?query=auth&type=sessions&limit=10"
curl -s "http://localhost:37777/api/search?query=auth&type=prompts&limit=10"
```

Exact search by subtype:

```bash
curl -s "http://localhost:37777/api/search/by-concept?concept=decision&limit=10&project=my-project"
curl -s "http://localhost:37777/api/search/by-file?filePath=src/auth&limit=10&project=my-project"
curl -s "http://localhost:37777/api/search/by-type?type=bugfix&limit=10&project=my-project"
```

Semantic shortcuts:

```bash
curl -s "http://localhost:37777/api/decisions?limit=20&project=my-project"
curl -s "http://localhost:37777/api/changes?limit=20&project=my-project"
curl -s "http://localhost:37777/api/how-it-works?limit=20&project=my-project"
```

Search help:

```bash
curl -s "http://localhost:37777/api/search/help"
```

## Result Handling

- Use `jq` if available to reduce JSON noise.
- Keep IDs, timestamps, and titles.
- Fetch exact records only after narrowing the candidate set.

## Fetch Exact Records

Observation by ID:

```bash
curl -s "http://localhost:37777/api/observation/11131"
```

Batch observations:

```bash
curl -s -X POST "http://localhost:37777/api/observations/batch" \
  -H "Content-Type: application/json" \
  -d '{"ids":[11131,10942],"project":"my-project"}'
```

## Codex Subagent Pattern

Keep these local:
- the HTTP search calls
- candidate filtering
- exact fetches by ID

Good delegation after retrieval:
- one agent clusters decisions
- one agent summarizes change history
- one agent compares sessions vs prompts for the same topic

Do not spawn an agent to replace one `curl` call.

## Common Mistakes

- Fetching full records before narrowing search results
- Using this skill for whole-project narratives instead of `claude-mem-timeline-report`
- Using this skill for plain three-step recall when `claude-mem-memory-search` is enough
