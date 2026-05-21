---
description: Review and validate an implementation task list — readiness check before handing off to a code-generation agent.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: Implementation readiness report
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Resolve spec directory: use arguments if given, otherwise read `.ai/current`.
   - If `.ai/current` is missing → stop, ask user to run `/spec` first.
   - Read `tasks.md`. If missing → ask user to run `/tasks` first.
2. Read `spec.md` and `plan.md` for context.
3. For each task, verify:
   - Acceptance criteria are testable and unambiguous.
   - Domain assignment is correct.
   - Dependencies are declared and ordering is valid.
   - Quality gates are measurable.
4. Flag tasks that are under-specified or have missing validation.
5. Identify cross-domain risks that could block implementation.
6. Return a readiness report — green / amber / red per task.

## Handoff note

When this report is green, hand the `tasks.md` to Claude or Codex running `/implement`.

## Rules

- Resolve from `.ai/current` when no args given.
- Analysis only — do not generate code.
- Each flag must include a suggested resolution.
