---
name: claude-mem-viewer-and-stream
description: Use when checking the claude-mem web viewer, inspecting the live SSE stream, confirming worker liveness, or giving the user the right local URLs to observe claude-mem activity.
---

# Claude-Mem Viewer And Stream For Codex

Use this skill for the UI surface and live stream, not for settings or search.

## Quick Checks

Health:

```bash
curl -sf http://localhost:37777/health
```

Viewer URL:

```text
http://localhost:37777/
```

SSE stream:

```bash
curl -N http://localhost:37777/stream
```

## Textual Snapshot

Pair viewer checks with:

```bash
curl -s "http://localhost:37777/api/stats"
curl -s "http://localhost:37777/api/projects"
curl -s "http://localhost:37777/api/processing-status"
```

## Browser Access

If opening a browser requires approval or is unavailable, do not block on it. Report the viewer URL and inspect the service through `curl` instead.

## Stream Guidance

- Use the stream for operator inspection, not long automated parsing.
- Stop the stream once you have the signal you need.
- If the stream is quiet, confirm health and processing status before concluding the worker is idle.

## Common Mistakes

- Treating `/stream` as a stable machine-readable batch API
- Using the viewer skill when the task is really search, settings, or queue recovery
