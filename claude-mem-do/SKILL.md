---
name: claude-mem-do
description: Use when asked to execute an existing implementation plan phase by phase and the work needs documentation-first implementation, explicit verification, anti-pattern checks, or careful handoffs between phases.
---

# Claude-Mem Do For Codex

Execute one phase at a time. In Codex, replace Claude subagents with:
- `update_plan` for phase tracking
- `spawn_agent` for bounded implementation and review work
- parallel shell reads for fact gathering
- direct implementation only when delegation would block the next step

## Workflow

1. Read the whole plan before editing anything.
2. Mark exactly one phase as `in_progress`.
3. Before each phase, gather only the local context needed:
   - read the referenced docs and example code
   - inspect the target files and adjacent patterns
   - verify APIs and command names before using them
4. Implement only the current phase.
5. After the phase, run all applicable checks:
   - tests
   - lint/typecheck/build commands
   - targeted `rg` checks for known anti-patterns
   - a brief code review against the phase requirements
6. Do not move to the next phase until the current one passes verification or you have a clear blocker.

## Codex Subagent Pattern

Use Codex subagents when the user permits subagent work and the phase can be decomposed cleanly.

### Recommended Delegation

- `worker` agent: implement one bounded task with clear file ownership
- `explorer` agent: inspect documentation, examples, or cross-file patterns
- local session: keep orchestration, integration, and final go/no-go decisions here

### Delegation Rules

- Give each agent one concrete objective.
- Assign an explicit write scope for `worker` agents.
- Tell workers they are not alone in the codebase and must not revert unrelated edits.
- Use `explorer` agents for read-only discovery when that work can happen in parallel with your own next step.
- Wait only when the result is on the critical path. Otherwise keep moving on non-overlapping work.

## Execution Rules

- Copy established patterns from the codebase or docs. Do not invent APIs that merely seem likely.
- Prefer small, reviewable edits over broad rewrites.
- If the plan references an external dependency or runtime behavior, confirm it exists locally before coding against it.
- Keep notes tied to evidence: commands run, files changed, tests passed, remaining risk.

## Verification Checklist

For each phase, prove all of the following:
- The intended files changed and unrelated files did not need accidental edits.
- The implementation matches the documented API or local pattern it copied.
- The main success path works.
- The obvious regression paths were checked.
- Any incomplete part is called out explicitly.

## Post-Phase Agent Roles

When the phase is substantial, prefer this sequence:
- implementation worker
- verification worker or local verification
- read-only review worker for code quality and anti-pattern checks

Do not create a commit worker unless the user explicitly asked for commits.

## Failure Modes To Prevent

- Starting implementation before reading the referenced pattern
- Quietly changing plan scope mid-phase
- Skipping tests because the change "looks small"
- Advancing after a partial pass instead of resolving or reporting the blocker
- Spawning multiple workers with overlapping write scopes
- Blocking on `wait_agent` when local work could continue
