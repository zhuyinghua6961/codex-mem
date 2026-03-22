---
name: claude-mem-queue-and-import-ops
description: Use when importing claude-mem data, checking or reprocessing pending work, or performing queue recovery actions after stuck, failed, or delayed memory processing.
---

# Claude-Mem Queue And Import Ops For Codex

Use this skill for operational mutation of claude-mem queue state and imported data.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

## Inspect Queue State First

```bash
curl -s "http://localhost:37777/api/processing-status"
curl -s "http://localhost:37777/api/pending-queue"
```

Do this before any processing or clearing action.

## Reprocess Pending Queue

```bash
curl -s -X POST "http://localhost:37777/api/pending-queue/process" \
  -H "Content-Type: application/json" \
  -d '{"sessionLimit":10}'
```

## Clear Queue Entries

Clear failed only:

```bash
curl -s -X DELETE "http://localhost:37777/api/pending-queue/failed"
```

Clear all:

```bash
curl -s -X DELETE "http://localhost:37777/api/pending-queue/all"
```

`pending-queue/all` is destructive. Use it only with explicit user intent.

## Import Data

```bash
curl -s -X POST "http://localhost:37777/api/import" \
  -H "Content-Type: application/json" \
  -d '{"sessions":[],"summaries":[],"observations":[],"prompts":[]}'
```

The endpoint imports sessions first, then summaries, observations, and prompts. Prefer validated export payloads.

## Codex Subagent Pattern

Keep the actual mutation local. If an import or queue snapshot is large, delegate only the analysis of the returned stats.

## Common Mistakes

- Clearing queue state before inspecting it
- Running import with obviously malformed or partial payloads
- Treating queue operations as harmless when they can discard recoverable work
