---
name: claude-mem-install-and-deploy
description: Use when installing, upgrading, configuring, or deploying claude-mem outside its existing runtime, including local installer flows, dependency setup, plugin installation expectations, and gateway or Cursor-related deployment paths.
---

# Claude-Mem Install And Deploy For Codex

This skill covers installation and deployment guidance, not day-to-day recall or operations.

## Platform Difference

Claude-mem's original installation model targets Claude Code plugins. Codex cannot natively reproduce `/plugin marketplace add` or `/plugin install`.

In Codex, adapt installation requests into one of these paths:
- install or configure the worker/runtime locally
- inspect or run the upstream installer assets
- guide deployment to another host platform such as Claude Code, Cursor, or OpenClaw

## Original Install Paths

Claude Code plugin flow from upstream docs:

```text
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

OpenClaw bootstrap:

```bash
curl -fsSL https://install.cmem.ai/openclaw.sh | bash
```

Installer bootstrap script in repo:

```bash
bash install/public/install.sh
```

Important:
- this bootstrap script downloads a remote `installer.js` from `install.cmem.ai`
- it is not an offline, source-pure install path
- it expects interactive terminal access

Local interactive installer from source checkout:

```bash
npx tsx installer/src/index.ts
```

Important:
- this source installer also requires an interactive terminal
- it exits early when `stdin` is not a TTY

Local built installer:

```bash
node install/public/installer.js
```

This is the closest local bundled install path because it runs the built installer already present in the repo.
The source-driven install path is still `npx tsx installer/src/index.ts`.
Both should be treated as interactive installer flows, not unattended automation.

The repo also contains:
- `installer/src/steps/*` for interactive install logic
- `scripts/smart-install.js` for Bun and uv bootstrap behavior

## Dependency Expectations

Upstream expects at least:
- Node.js >= 18
- Bun
- uv

Useful checks:

```bash
node -v
bun --version
uv --version
```

## Repo-Local Development Install

In a repo checkout, relevant commands include:

```bash
npm install
npm run build
npm run worker:start
npm run worker:status
```

Cursor-related deployment paths also exist:

```bash
npm run cursor:install
npm run cursor:status
```

## Deployment Guidance

Use this skill to:
- explain which install path matches the target platform
- verify prerequisites before starting
- distinguish SDK/library install from plugin/runtime install
- explain what Codex can and cannot do natively

Choose the concrete path:
- want upstream plugin behavior on Claude Code: use the documented `/plugin` flow on Claude Code, not Codex
- want to run the installer from a repo checkout with the checked-out source in an interactive shell: use `npx tsx installer/src/index.ts`
- want to run the bundled built installer already in the repo in an interactive shell: use `node install/public/installer.js`
- want the upstream bootstrap experience: use `bash install/public/install.sh`, but note that it downloads a remote installer and requires a TTY
- want OpenClaw gateway deployment: use the OpenClaw bootstrap script
- want local development runtime only: use `npm install`, `npm run build`, and worker commands

## Common Mistakes

- assuming `npm install -g claude-mem` reproduces plugin behavior
- skipping Bun or uv checks
- treating Claude Code plugin install steps as Codex-native
- pointing to installer assets without giving the runnable local command
- implying that `install/public/install.sh` is a purely local install path when it actually downloads a remote installer
- presenting the source or built installers as non-interactive automation paths
