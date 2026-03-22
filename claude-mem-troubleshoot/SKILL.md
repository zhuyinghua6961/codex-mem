---
name: claude-mem-troubleshoot
description: Use when claude-mem appears unhealthy, the worker or viewer is failing, the queue is stuck, logs need inspection, or the user needs a systematic diagnosis of memory processing problems.
---

# Claude-Mem Troubleshoot For Codex

Use a fixed diagnostic order: health, status, logs, queue, database.

## Step 1: Health And Status

```bash
curl -sf http://localhost:37777/health
curl -s "http://localhost:37777/api/processing-status"
curl -s "http://localhost:37777/api/stats"
```

If the worker is unreachable, check the local port:

```bash
lsof -i :37777
```

## Step 2: Logs

Tail recent lines:

```bash
curl -s "http://localhost:37777/api/logs?lines=200"
```

Clear logs only if the user explicitly wants that:

```bash
curl -s -X POST "http://localhost:37777/api/logs/clear"
```

## Step 3: Queue Diagnosis

```bash
curl -s "http://localhost:37777/api/pending-queue"
```

Look for:
- failed messages
- stuck processing entries
- sessions with pending work

Process pending work only after inspection:

```bash
curl -s -X POST "http://localhost:37777/api/pending-queue/process" \
  -H "Content-Type: application/json" \
  -d '{"sessionLimit":10}'
```

## Step 4: Database Sanity

If the worker is up but results look wrong:

```bash
sqlite3 ~/.claude-mem/claude-mem.db "PRAGMA integrity_check;"
sqlite3 ~/.claude-mem/claude-mem.db "SELECT COUNT(*) FROM observations;"
```

## Codex Subagent Pattern

Keep the commands local. Good delegation after retrieval:
- one agent clusters repeated error signatures from logs
- one agent summarizes queue failure patterns

## Common Mistakes

- clearing logs before reading them
- clearing queue state before understanding it
- blaming search quality when the worker itself is unhealthy
