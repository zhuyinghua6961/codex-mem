---
name: claude-mem-session-runtime
description: Use when adapting claude-mem's automatic hook-driven session lifecycle to Codex or other external automation, including session init, observation queuing, summarize requests, completion, and privacy-aware runtime behavior.
---

# Claude-Mem Session Runtime For Codex

This is the closest Codex analogue to claude-mem's automatic operation. Codex does not natively gain Claude Code hooks, but external scripts can drive the worker through the session lifecycle API.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

Prefer the `contentSessionId` endpoints under `/api/sessions/*`.

Only `contentSessionId` is truly required for init. `project` and `prompt` are optional and may be omitted by some clients.
If omitted, upstream defaults them to `project="unknown"` and `prompt="[media prompt]"`, and that cleaned prompt still participates in session initialization and prompt storage unless privacy rules skip it.

## Session Lifecycle

Initialize with explicit project and prompt:

```bash
curl -s -X POST "http://localhost:37777/api/sessions/init" \
  -H "Content-Type: application/json" \
  -d '{"contentSessionId":"session-123","project":"my-project","prompt":"Investigate auth bug"}'
```

Minimal valid init:

```bash
curl -s -X POST "http://localhost:37777/api/sessions/init" \
  -H "Content-Type: application/json" \
  -d '{"contentSessionId":"session-123"}'
```

Queue an observation:

```bash
curl -s -X POST "http://localhost:37777/api/sessions/observations" \
  -H "Content-Type: application/json" \
  -d '{"contentSessionId":"session-123","tool_name":"Bash","tool_input":{"command":"pytest"},"tool_response":{"output":"..."},"cwd":"/repo"}'
```

Queue summarize:

```bash
curl -s -X POST "http://localhost:37777/api/sessions/summarize" \
  -H "Content-Type: application/json" \
  -d '{"contentSessionId":"session-123","last_assistant_message":"Root cause identified and patch validated."}'
```

Complete:

```bash
curl -s -X POST "http://localhost:37777/api/sessions/complete" \
  -H "Content-Type: application/json" \
  -d '{"contentSessionId":"session-123"}'
```

## Important Return States

Do not assume every lifecycle call returns a simple success.

`/api/sessions/init` may return:
- `{ sessionDbId, promptNumber, skipped: true, reason: "private" }`
- `{ sessionDbId, promptNumber, skipped: false, contextInjected: boolean }`

`/api/sessions/observations` may return:
- `{ status: "queued" }`
- `{ status: "skipped", reason: "tool_excluded" }`
- `{ status: "skipped", reason: "session_memory_meta" }`
- `{ status: "skipped", reason: "private" }`
- `{ stored: false, reason: "..." }` on recoverable storage failures

`/api/sessions/summarize` may return:
- `{ status: "queued" }`
- `{ status: "skipped", reason: "private" }`

`/api/sessions/complete` may return:
- `{ status: "completed", sessionDbId }`
- `{ status: "skipped", reason: "not_active" }`

External automation should branch on these responses instead of treating them all as hard failures.

## Legacy Session IDs

If you already have the numeric `sessionDbId`, legacy endpoints still exist under `/sessions/:sessionDbId/*`. Prefer the newer content-session form unless you have a strong reason not to.

Typical legacy management flow after init returns `sessionDbId`:

Status:

```bash
curl -s "http://localhost:37777/sessions/42/status"
```

Delete active session state:

```bash
curl -s -X DELETE "http://localhost:37777/sessions/42"
```

Legacy complete:

```bash
curl -s -X POST "http://localhost:37777/sessions/42/complete"
```

Use the legacy endpoints when you specifically need runtime status or numeric-session cleanup behavior.

## Privacy Behavior

Hook-driven runtime behavior includes privacy-aware handling:
- prompts wrapped entirely in private tags may be skipped
- tool input and tool response have memory tags stripped before queueing
- some tools may be skipped by runtime policy before storage
- file operations against `session-memory` files may be skipped as meta-observations

If you are building external automation around these endpoints, preserve that expectation and do not assume every prompt will be stored.

## What This Does Not Recreate

- native Claude Code hook registration
- Claude Desktop integration as a first-class Codex feature

Those remain platform-specific. The portable part is the worker HTTP lifecycle, not the host application's plugin model.

## Common Mistakes

- forgetting `contentSessionId`
- sending observations before session init exists in your external workflow
- assuming automatic hook behavior exists without an external driver script
- forgetting that status and delete are exposed only on the legacy numeric-session endpoints
- treating `skipped` or `stored:false` responses as undocumented anomalies
