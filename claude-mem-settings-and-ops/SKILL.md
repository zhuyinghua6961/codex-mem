---
name: claude-mem-settings-and-ops
description: Use when managing claude-mem runtime settings, checking administrative status, toggling MCP availability, switching branches or beta channels, or inspecting worker and database state.
---

# Claude-Mem Settings And Ops For Codex

This skill covers administrative controls, not historical recall.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

## Read And Update Settings

Read current settings first:

```bash
curl -s "http://localhost:37777/api/settings"
```

Update only the minimum keys needed:

```bash
curl -s -X POST "http://localhost:37777/api/settings" \
  -H "Content-Type: application/json" \
  -d '{"CLAUDE_MEM_WORKER_PORT":"37777"}'
```

## MCP Runtime Controls

```bash
curl -s "http://localhost:37777/api/mcp/status"
curl -s -X POST "http://localhost:37777/api/mcp/toggle" \
  -H "Content-Type: application/json" \
  -d '{"enabled":true}'
```

## Branch And Beta Controls

Current branch:

```bash
curl -s "http://localhost:37777/api/branch/status"
```

Switch branch:

```bash
curl -s -X POST "http://localhost:37777/api/branch/switch" \
  -H "Content-Type: application/json" \
  -d '{"branch":"beta/7.0"}'
```

Pull latest updates:

```bash
curl -s -X POST "http://localhost:37777/api/branch/update"
```

Branch switch and update may restart the worker. Say that before using them.

## Administrative State

```bash
curl -s "http://localhost:37777/api/stats"
curl -s "http://localhost:37777/api/projects"
curl -s "http://localhost:37777/api/processing-status"
```

Use these for a quick operator snapshot.

## Rules

- Read before you write.
- Change the smallest possible settings payload.
- Treat branch switching as disruptive.
- Do not pretend MCP toggle makes Codex gain Claude-native plugin behavior; it only changes claude-mem runtime state.

## Common Mistakes

- Blindly overwriting settings instead of patching one key
- Switching branches without warning about restart risk
- Mixing configuration work with search or troubleshooting tasks
