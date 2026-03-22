---
name: claude-mem-context-tools
description: Use when working with claude-mem context injection, recent context, timeline windows, worktree-aware project context, or previewing the exact memory block that would be injected.
---

# Claude-Mem Context Tools For Codex

These endpoints return context blocks and timeline windows, not just search hits. Prefer them when the user wants to see what memory would be injected or what surrounded a point in time.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

## Recent Context

```bash
curl -s "http://localhost:37777/api/context/recent?project=my-project&limit=3"
```

Use this for quick “what has happened lately?” snapshots.

## Context Timeline

Around an anchor:

```bash
curl -s "http://localhost:37777/api/context/timeline?anchor=123&depth_before=10&depth_after=10&project=my-project"
```

By best query match:

```bash
curl -s "http://localhost:37777/api/timeline/by-query?query=authentication&depth_before=10&depth_after=10&project=my-project"
```

Use this for chronology, not for a full narrative report.

## Preview And Inject

Preview plain-text injected context:

```bash
curl -s "http://localhost:37777/api/context/preview?project=my-project"
```

Injected context for one project:

```bash
curl -s "http://localhost:37777/api/context/inject?project=my-project&colors=true"
```

Full context:

```bash
curl -s "http://localhost:37777/api/context/inject?project=my-project&full=true"
```

Worktree-aware multi-project inject:

```bash
curl -s "http://localhost:37777/api/context/inject?projects=parent-repo,feature-worktree&colors=true"
```

## Worktree Rule

If the current directory is a git worktree, prefer the parent repo plus worktree name when the user wants unified history. Do not silently assume only the leaf directory matters.

## Codex Subagent Pattern

Fetch the context locally first. If the returned block is large:
- split it into bounded chunks
- delegate chunk summarization
- keep the final synthesis local

## Common Mistakes

- Using `project=` when the real need is `projects=parent,worktree`
- Treating context preview text as JSON
- Using this skill for direct record fetches instead of `claude-mem-data-inspection`
