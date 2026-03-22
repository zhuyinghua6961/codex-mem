---
name: claude-mem-save-memory
description: Use when the user wants to manually save a memory into claude-mem, seed an important observation, or needs guidance on privacy and what content should or should not be stored.
---

# Claude-Mem Save Memory For Codex

Use this skill to write a manual observation into claude-mem. This is the Codex substitute for “remember this” workflows.

## Prerequisites

```bash
curl -sf http://localhost:37777/health
```

## Save A Manual Memory

```bash
curl -s -X POST "http://localhost:37777/api/memory/save" \
  -H "Content-Type: application/json" \
  -d '{"text":"Documented the root cause of the auth race.","title":"Auth race root cause","project":"my-project"}'
```

Fields:
- `text` required
- `title` optional
- `project` optional, but should usually be explicit

## Privacy Rules

Manual save writes exactly what you send. Do not rely on automatic privacy stripping here.

Important distinction:
- Hook-driven session ingestion strips `<private>...</private>` blocks from prompts and may skip a prompt that is entirely private.
- Manual `memory/save` does not provide that safeguard in this workflow.

If the content contains secrets, redact them before saving.

## After Saving

- Capture the returned observation ID.
- Use `claude-mem-memory-search` or `claude-mem-data-inspection` to verify it was stored.

## Good Uses

- preserving a hard-won debugging insight
- recording a design decision not yet visible in code
- saving a migration checklist or operational note

## Bad Uses

- dumping raw secrets
- storing huge transcripts as one manual memory
- using manual save when bulk import is the real need
