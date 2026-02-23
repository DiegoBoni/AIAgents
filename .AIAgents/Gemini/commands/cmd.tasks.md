---
description: Generate a prioritized backlog from a plan.
arguments: Path to plan file
output: specs/<feature>/tasks.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Break plan into small tasks.
2. Tag each task with priority (P1/P2/P3).
3. Add definition of done per task.
4. Save `tasks.md`.
5. Return recommended execution order.
