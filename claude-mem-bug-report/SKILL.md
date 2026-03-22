---
name: claude-mem-bug-report
description: Use when creating a claude-mem bug report, collecting runtime diagnostics for an issue, or preparing a reproducible report for GitHub without manually assembling logs, versions, and worker status.
---

# Claude-Mem Bug Report For Codex

Use this skill when the user wants a support-ready bug report instead of an ad hoc troubleshooting summary.

## Preferred Path In A Claude-Mem Checkout

If you are inside a `claude-mem` repository checkout with dependencies available, use the built-in generator:

```bash
npm run bug-report
```

Important:
- the upstream generator is interactive
- it prompts for issue description, expected behavior, and reproduction steps
- it is best suited to a human-operated terminal, not unattended automation
- without `--output`, it also saves a timestamped markdown report in the home directory and prints the result to the terminal

Options supported by the original CLI:

```bash
npm run bug-report -- --no-logs
npm run bug-report -- --verbose
npm run bug-report -- --output ~/my-bug-report.md
```

The original script is implemented in:
- `scripts/bug-report/cli.ts`
- `scripts/bug-report/collector.ts`

## What The Generator Collects

The built-in workflow gathers:
- claude-mem version
- Claude Code version when available
- platform and architecture
- worker running state, PID, and port
- configuration
- recent logs unless `--no-logs` is used

Then it prompts for:
- issue description
- expected behavior
- reproduction steps

Default artifact behavior:
- saves to `~/bug-report-YYYY-MM-DD-HHMMSS.md`
- also displays the generated report in the terminal

## Fallback When The Generator Is Unavailable

If `npm run bug-report` cannot run, or the environment is non-interactive, collect the minimum report bundle manually:

```bash
curl -sf http://localhost:37777/health
curl -s "http://localhost:37777/api/stats"
curl -s "http://localhost:37777/api/processing-status"
curl -s "http://localhost:37777/api/logs?lines=200"
```

Also capture:
- current settings from `/api/settings`
- exact reproduction steps
- whether private logs were intentionally omitted

## Privacy Rules

- Offer `--no-logs` when logs may contain sensitive data.
- Do not include secrets just because the report format accepts them.
- Say explicitly if logs were omitted, truncated, or redacted.

## Codex Subagent Pattern

Keep command execution local. Good delegation after collection:
- one agent summarizes error signatures from logs
- one agent turns diagnostics into a concise GitHub-ready issue

## Common Mistakes

- filing a report without reproduction steps
- attaching logs without checking for secrets
- using troubleshooting notes as a substitute for a structured bug report
