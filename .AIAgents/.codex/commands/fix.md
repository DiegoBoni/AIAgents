---
description: Fix a bug with minimal context — loads only the domain section relevant to the affected file.
arguments: Bug description and/or file path(s)
output: Code fix + root cause summary
---

## User Input

```text
$ARGUMENTS
```

## Goal

Diagnose and fix the bug with the smallest possible context footprint.
Load only the domain section that matches the affected code — nothing else.

## Steps

1. Read the bug description and identify the affected file(s).
2. Determine the domain from the file path or description:
   - API / service / auth → `[context.backend]`
   - Component / page / state → `[context.frontend]`
   - Migration / model / query → `[context.data]`
   - Test file → `[context.testing]`
   - Pipeline / infra / config → `[context.devops]`
3. Read **only** that domain section from `.ai/project-context.md`.
4. Read the affected file(s) — no more than needed.
5. Identify root cause.
6. Apply the minimal fix. Run lint and relevant tests after.
7. Return: root cause, fix summary, test result, cross-domain flags.

## Output

- Fixed file(s)
- Root cause: one sentence
- Fix summary: what changed and why
- Lint/test result
- Cross-domain impact flags (if any)

## Rules

- Load only the matching domain section — not the full project context
- Do not refactor surrounding code unless it is the direct cause
- Run tests after fixing — report pass/fail
- If fix touches multiple domains, flag and split into separate tasks
