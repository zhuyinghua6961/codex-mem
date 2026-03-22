---
name: claude-mem-for-codex
description: Use when the task involves any claude-mem workflow in Codex, including recall, advanced history search, manual memory saving, context injection, installation or deployment, viewer or runtime operations, maintenance or export tasks, bug reporting, troubleshooting, or claude-mem-style planning and execution.
---

# Claude-Mem For Codex

This is the entry skill for the Codex-adapted claude-mem workflow set.

## Routing

After this skill triggers, load the matching sibling skill:

- previous-session recall, "did we solve this before?", older implementation history
  - read `../claude-mem-memory-search/SKILL.md`
- advanced search modes, decisions, changes, how-it-works, sessions, prompts, by-file, by-type
  - read `../claude-mem-advanced-search/SKILL.md`
- raw records, citations, paginated data inspection, stats, project inventory
  - read `../claude-mem-data-inspection/SKILL.md`
- manually saving a memory or deciding what is safe to store
  - read `../claude-mem-save-memory/SKILL.md`
- context injection, preview, recent context, worktree-aware multi-project history
  - read `../claude-mem-context-tools/SKILL.md`
- external automation for session init, observation queueing, summarize, and completion
  - read `../claude-mem-session-runtime/SKILL.md`
- project journey report, long-form history analysis, timeline narrative
  - read `../claude-mem-timeline-report/SKILL.md`
- feature planning, phased migration plans, doc-first implementation plans
  - read `../claude-mem-make-plan/SKILL.md`
- executing an existing phased plan with verification and review gates
  - read `../claude-mem-do/SKILL.md`
- token-efficient codebase discovery before reading full files
  - read `../claude-mem-smart-explore/SKILL.md`
- installation, deployment, prerequisite setup, gateway or plugin-style install questions
  - read `../claude-mem-install-and-deploy/SKILL.md`
- worker lifecycle commands, export workflows, or Cursor setup and uninstall maintenance tasks
  - read `../claude-mem-export-and-maintenance/SKILL.md`
- worker settings, beta channel, MCP runtime state, administrative status
  - read `../claude-mem-settings-and-ops/SKILL.md`
- viewer URL, SSE stream, liveness checks
  - read `../claude-mem-viewer-and-stream/SKILL.md`
- queue recovery, queue reprocessing, data import
  - read `../claude-mem-queue-and-import-ops/SKILL.md`
- logs, health, stuck worker diagnosis, queue troubleshooting
  - read `../claude-mem-troubleshoot/SKILL.md`
- support-ready issue filing and automated diagnostics collection
  - read `../claude-mem-bug-report/SKILL.md`

If more than one applies, use the smallest useful combination in this order:
1. `claude-mem-smart-explore` for discovery
2. `claude-mem-make-plan` for planning
3. `claude-mem-do` for execution

For memory-backed tasks:
1. `claude-mem-memory-search` for targeted recall
2. `claude-mem-advanced-search` for specialized query modes
3. `claude-mem-data-inspection` for exact records and citations
4. `claude-mem-context-tools` for injected or recent context
5. `claude-mem-timeline-report` only when the user wants whole-project history

For operational tasks:
1. `claude-mem-install-and-deploy` for setup and deployment questions
2. `claude-mem-export-and-maintenance` for worker lifecycle, export, and Cursor maintenance
3. `claude-mem-settings-and-ops` for configuration and branch state
4. `claude-mem-viewer-and-stream` for UI and live stream checks
5. `claude-mem-session-runtime` for hook-style automation and lifecycle parity
6. `claude-mem-queue-and-import-ops` for queue mutation or import
7. `claude-mem-troubleshoot` for diagnosis and recovery
8. `claude-mem-bug-report` for structured issue filing

## Shared Rules

- Prefer Codex-native tools and subagents over Claude-specific plugin assumptions.
- Keep retrieval local when the next action is blocked on one command or query.
- Use subagents for bounded parallel synthesis, not for trivial shell calls.
- Distinguish facts retrieved from claude-mem from your own inference.
- Claude Code hooks and Claude Desktop integration are not directly portable to Codex. Adapt them as worker, database, and HTTP workflows instead of pretending they are native Codex features.
