---
name: claude-mem-smart-explore
description: Use when exploring a large or unfamiliar codebase and you need a token-efficient map of files, symbols, and targeted snippets before deciding whether to read full files, especially in a claude-mem checkout or another repo where AST tooling is available.
---

# Claude-Mem Smart Explore For Codex

Keep the original principle: index first, fetch on demand. Prefer real AST-based exploration when the local environment supports it. Fall back to `rg` and targeted reads only when the AST path is unavailable.

When the task shifts from precision lookup to cross-file understanding, hand that synthesis to an `explorer` agent instead of continuing to open more files blindly.

## High-Fidelity AST Mode

If you are inside a `claude-mem` checkout and its smart-file-read dependencies are present, prefer the original engine in:
- `src/services/smart-file-read/search.ts`
- `src/services/smart-file-read/parser.ts`

It uses `tree-sitter-cli` plus grammar packages declared in `package.json`.

Use AST mode when:
- symbol boundaries matter
- files are large
- you want an outline without reading full implementations

Practical rule:
- if the repo already has `tree-sitter-cli` and grammar packages installed, use the AST path
- otherwise use the shell fallback below

Helper scripts in this skill package:
- `scripts/smart-search-from-claude-mem.sh`
- `scripts/smart-outline-from-claude-mem.sh`
- `scripts/smart-unfold-from-claude-mem.sh`

Run them from this skill directory, or reference them by absolute path from elsewhere.

Example commands:

```bash
# from the claude-mem-smart-explore skill directory
bash scripts/smart-search-from-claude-mem.sh /path/to/claude-mem "shutdown" ./src 15
bash scripts/smart-outline-from-claude-mem.sh /path/to/claude-mem ./src/services/worker-service.ts
bash scripts/smart-unfold-from-claude-mem.sh /path/to/claude-mem ./src/services/worker-service.ts startSessionProcessor
```

These wrappers call the original smart-file-read engine through `npx tsx`. If `npx tsx` or repo dependencies are missing, drop to the shell fallback.

## Default Shell Fallback Workflow

### Step 1: Discover Files And Symbols

Start with file lists and symbol search:

```bash
rg --files src
rg -n "shutdown|graceful|WorkerService" src
```

Use globs to stay narrow:

```bash
rg -n "createSession|SessionManager" src --glob '*.ts'
```

### Step 2: Build A Lightweight Outline

Do not read the whole file yet. First inspect:
- imports
- exported symbols
- matching line numbers from `rg`
- short targeted windows around matches

Useful pattern:

```bash
nl -ba path/to/file.ts | sed -n '1,220p'
```

Or around a match:

```bash
nl -ba path/to/file.ts | sed -n '120,220p'
```

### Step 3: Read Only The Needed Implementation

After locating the relevant symbol, read only the narrow range that contains it. Read the full file only when:
- the symbol boundaries are unclear
- file-level state matters
- the file is already small

## Codex Subagent Pattern

Use local shell discovery first. Then:
- use an `explorer` agent for questions like "how does this subsystem work end-to-end?"
- use parallel `explorer` agents when there are multiple unrelated codebase questions

Do not delegate the immediate next grep or file read if you are blocked on it. Do that locally and keep momentum.

## Tool Selection

- `rg --files`: file discovery
- `rg -n`: symbol or string discovery
- `nl -ba ... | sed -n`: targeted context with stable line numbers
- full file reads: only after the above steps fail to answer the question

If `tree-sitter-cli` or repo-native AST helpers are available, prefer them over the fallback shell workflow. If `ast-grep` is installed, it can also help, but the canonical high-fidelity path is the original claude-mem smart-file-read engine via the helper scripts above.

## AST-First Decision Rule

Use AST mode first when any of these are true:
- the user explicitly wants function, class, or method structure
- the target file is large enough that full reads are wasteful
- you need exact symbol unfolding rather than approximate grep windows

Use shell fallback first when:
- the codebase is not the claude-mem repo and no AST tooling is available
- the target files are small
- you only need exact string matches

## When Not To Use This Skill

- tiny files where a full read is cheaper
- non-code artifacts such as short JSON or markdown files
- broad architecture questions that require cross-file synthesis rather than precision lookup

For that third case, switch to an `explorer` agent after the initial map is built.

## Failure Modes To Prevent

- opening many full files before narrowing the search
- reading giant generated files because a search hit looked promising
- confusing string matches with the real call path or ownership boundary
- delegating trivial file lookups that are faster to do locally
- claiming AST-level certainty when you actually used only grep-based fallback
