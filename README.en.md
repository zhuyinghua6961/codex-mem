[English](./README.en.md) | [中文](./README.md)

# codex-mem

Codex-adapted skills for [`thedotmack/claude-mem`](https://github.com/thedotmack/claude-mem).

This repository does not reimplement Claude Code's native plugin system. It adapts the useful `claude-mem` workflows into Codex-native skills, shell commands, and operational playbooks.

## What This Repo Contains

The repository currently includes:

- an entry skill: `claude-mem-for-codex`
- memory search and advanced search skills
- context, viewer, settings, queue, troubleshooting, and session runtime skills
- planning and execution skills adapted for Codex subagents
- helper scripts for higher-fidelity `smart-explore` workflows

The skills live as one directory per skill:

```text
claude-mem-for-codex/
claude-mem-memory-search/
claude-mem-advanced-search/
...
```

## Scope

This project aims to preserve the practical value of `claude-mem` inside Codex:

- recall previous work from a running `claude-mem` worker or database
- inspect observations, prompts, sessions, and timelines
- manage viewer, settings, queue, and troubleshooting flows
- adapt session lifecycle APIs for external automation
- preserve the original plan/do/smart-explore workflows in Codex form

It does not make Codex natively support:

- Claude Code `/plugin` commands
- Claude Code hook registration
- Claude Desktop integration as a first-class Codex feature

Those parts are represented as equivalent worker, HTTP, database, or script workflows where possible.

## Install Into Codex

Codex skill discovery expects each skill directory to be available under `~/.agents/skills/`.

The safest installation method is to symlink each skill directory into that location.

Example:

```bash
mkdir -p ~/.agents/skills

for dir in /path/to/codex-mem/*; do
  [ -d "$dir" ] || continue
  ln -s "$dir" "$HOME/.agents/skills/$(basename "$dir")"
done
```

If a link already exists, remove or replace it first.

After linking the skills, restart Codex so it can rediscover them.

## Recommended Starting Point

If you are using this skill set manually, start with:

- `claude-mem-for-codex`

It routes to the more specific skills for:

- recall and advanced search
- context injection and timeline reporting
- settings, maintenance, queue operations, and troubleshooting
- planning and execution

## Operational Assumptions

Many of the skills assume one of the following is available:

- a running `claude-mem` worker at `http://localhost:37777`
- a local `claude-mem` database at `~/.claude-mem/claude-mem.db`
- a local `claude-mem` source checkout for script-based workflows

Some skills are useful even without a running worker, but most memory and runtime operations depend on one of those environments.

## Smart Explore

`claude-mem-smart-explore` supports two modes:

- a higher-fidelity AST mode using the original `claude-mem` smart-file-read engine
- a shell fallback using `rg` and targeted file reads

The AST helper scripts are in:

```text
claude-mem-smart-explore/scripts/
```

## Repository Status

This repo is a practical migration/adaptation layer, not an official upstream distribution.

If you need original plugin behavior, use the upstream `claude-mem` project directly.
