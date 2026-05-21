---
description: Generate actionable tasks from a plan.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: specs/features/<slug>/tasks.md  (or specs/bugs/<slug>/tasks.md)
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Resolve spec directory: use arguments if given, otherwise read `.ai/current`.
   - If `.ai/current` is missing → stop, ask user to run `/spec` first.
   - Read `plan.md` from the directory. If missing → ask user to run `/plan` first.
2. Convert phases into independently testable tasks with domain, dependencies, and validation.
3. Add priority and parallel flag per task.
4. Save `tasks.md` in the same directory.
5. Return ordered execution list grouped by domain.

## Rules

- Resolve from `.ai/current` when no args given.
- One domain per task — never mix.
- Validation must be concrete and verifiable.
