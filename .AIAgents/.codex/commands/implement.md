---
description: Execute implementation tasks from a feature task list, one domain at a time.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: Code changes per task
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Resolve spec directory: use arguments if given, otherwise read `.ai/current`.
   - If `.ai/current` is missing → stop, ask user to run `/spec` first.
   - Read `tasks.md`. If missing → ask user to run `/tasks` first.
2. Read `plan.md` for constraints and quality gates.
3. Group tasks by domain. For each task in dependency order:
   a. Load `.codex/skills/<domain>/SKILL.md`.
   b. Read only `[context.<domain>]` from `.ai/project-context.md`.
   c. Implement the minimum change satisfying the task's validation criteria.
   d. Log cross-domain impacts — do not resolve them in the same step.
4. Return per-task summary: files changed, validation status, flags.

## Rules

- Resolve from `.ai/current` when no args given.
- Load only the domain section needed.
- One domain per step — never mix backend and frontend in a single task.
