---
description: Fix a bug with minimal context. Add --trace to create a bug spec in specs/bugs/ for traceability.
arguments: Bug description and/or file path(s). Optional: --trace
output: Code fix + root cause summary. With --trace: also specs/bugs/<slug>/spec.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Parse `--trace` flag. If present, create `specs/bugs/<slug>/spec.md` and update `.ai/current`.
2. Determine domain from file path or description.
3. Read only `[context.<domain>]` from `.ai/project-context.md`.
4. Read the affected file(s) — no more.
5. Identify root cause. Apply minimal fix. Run lint and relevant tests.
6. Return: root cause, fix summary, test result, cross-domain flags.
7. If `--trace`: update `spec.md` with actual root cause and fix summary.

## Rules

- Load only the matching domain section.
- Do not refactor surrounding code unless it causes the bug.
- `--trace` is opt-in — skip for trivial one-line fixes.
