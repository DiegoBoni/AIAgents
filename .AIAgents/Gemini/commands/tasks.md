---
description: Generate a prioritized backlog from a plan.
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
2. Break plan into small tasks. Tag each with: domain, priority (P1/P2/P3), dependencies, parallel flag.
3. Add definition of done per task.
4. Save `tasks.md` in the same directory.
5. Return recommended execution order and parallelizable batches.

## Rules

- Resolve from `.ai/current` when no args given.
- Gemini's value here: surface sequencing risks and missing dependencies before implementation.
- One domain per task — split cross-domain work explicitly.
