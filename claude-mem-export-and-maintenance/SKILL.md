---
name: claude-mem-export-and-maintenance
description: Use when running claude-mem maintenance commands such as worker start or restart, exporting memories, or performing Cursor setup, status, or uninstall tasks from a local claude-mem checkout.
---

# Claude-Mem Export And Maintenance For Codex

Use this skill for script-level maintenance tasks that are not plain settings changes.

## Worker Lifecycle

From a local `claude-mem` checkout:

```bash
npm run worker:start
npm run worker:stop
npm run worker:restart
npm run worker:status
```

Log helpers also exist:

```bash
npm run worker:logs
npm run worker:tail
```

Use these when the task is operational control of the local runtime rather than HTTP inspection.

Queue script helpers also exist:

```bash
npm run queue
npm run queue:process
npm run queue:clear
```

Use these when the user wants the upstream script workflow for queue inspection or recovery rather than the HTTP API.
`npm run queue:clear` is destructive and should only be used with explicit user intent.

## Export Memories

The repo ships a dedicated export script:

```bash
npx tsx scripts/export-memories.ts "authentication" auth-memories.json --project=my-project
```

Use export when the user wants:
- a portable memory bundle
- filtered memories by query
- an artifact for transfer or backup

## Import Memories

There is also a script-level import path in addition to the HTTP API:

```bash
npx tsx scripts/import-memories.ts auth-memories.json
```

Use the script path when the user is operating from a repo checkout and wants the upstream workflow rather than raw HTTP.

## Cursor Maintenance

The package exposes:

```bash
npm run cursor:install
npm run cursor:status
npm run cursor:setup
npm run cursor:uninstall
```

Use these when the user is integrating claude-mem with Cursor or removing that integration.

## When To Use This Instead Of Other Skills

- use this skill for local repo scripts and lifecycle commands
- use `claude-mem-queue-and-import-ops` for worker HTTP queue mutation
- use `claude-mem-settings-and-ops` for `/api/settings`, branch, and MCP runtime state
- use `claude-mem-install-and-deploy` for initial install path selection

## Common Mistakes

- using HTTP queue operations when the user actually wants the upstream script workflow
- restarting the worker when a read-only status check would answer the question
- forgetting that export/import script paths assume a repo checkout with dependencies available
- treating `npm run queue:clear` as a harmless cleanup command
