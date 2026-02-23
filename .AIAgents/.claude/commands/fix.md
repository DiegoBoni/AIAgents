---
description: Fix a bug with minimal context — loads only the domain section relevant to the affected file.
arguments: Bug description and/or file path(s)
output: Code fix + explanation
---

## User Input

```text
$ARGUMENTS
```

## Goal

Diagnose and fix the bug using the smallest possible context footprint.
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
5. Identify root cause. If unclear, state the hypothesis before fixing.
6. Apply the minimal fix that resolves the bug without side effects.
7. Flag any related risks or follow-up needed in other domains.

## Output

- Fixed file(s)
- Root cause: one sentence
- Fix summary: what changed and why
- Follow-up flags (if the fix has cross-domain impact)

## Rules

- Do not load the full `project-context.md` — only the matching domain section
- Do not refactor surrounding code unless it is the direct cause of the bug
- If the root cause is unclear after reading the file, ask before guessing
- If the fix touches multiple domains, flag it and split into separate tasks
