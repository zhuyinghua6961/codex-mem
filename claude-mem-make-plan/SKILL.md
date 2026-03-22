---
name: claude-mem-make-plan
description: Use when asked to plan a feature, migration, refactor, or multi-step task and the plan needs documentation discovery, phase boundaries, concrete file targets, and verification checklists for later execution.
---

# Claude-Mem Make Plan For Codex

Write plans that survive context resets. In Codex, do synthesis locally, and use subagents only for bounded fact gathering.

## Phase 0 Always Comes First

Before writing implementation phases:
- inspect the repo structure
- find existing examples and adjacent patterns
- read the relevant docs, types, and entry points
- record the allowed APIs, exact file paths, and known non-goals

Prefer parallel reads or `explorer` agents for discovery when possible.

## Codex Subagent Pattern

Use `explorer` agents for:
- locating the right files and examples
- extracting exact API names and signatures
- identifying existing local patterns to copy

Keep these local:
- choosing phase boundaries
- deciding sequencing
- writing the final plan text

Subagent outputs should include:
- sources read
- concrete findings
- exact file paths or symbols
- gaps or uncertainty

Reject agent findings that do not cite evidence.

## Plan Shape

Each phase should be executable on its own and include:
- goal
- files likely to change
- concrete references to copy from
- implementation steps
- verification commands
- anti-pattern guards
- exit criteria

## Planning Rules

- Plan from evidence, not assumptions.
- Prefer "copy this local pattern" over "refactor toward this abstract design".
- Keep phases small enough that one phase can be implemented and verified in one session.
- If a dependency, tool, or API is uncertain, create a discovery task before any implementation task.
- Separate mechanical migration work from behavioral changes whenever possible.
- If two discovery questions are independent, delegate them in parallel instead of serializing them.

## Suggested Output Format

Use this structure:

```md
## Phase 0: Discovery
- Findings
- Allowed APIs
- Risks

## Phase 1: ...
- Goal
- Files
- Steps
- Verification
- Anti-patterns
- Exit criteria
```

## Anti-Patterns To Prevent

- Plans that name outcomes but not files or references
- Phases with no verification step
- Telling the implementer to invent missing pieces later
- Mixing unrelated changes into the same phase
- Asking subagents to "figure everything out" without a scoped question
