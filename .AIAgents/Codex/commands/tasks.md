---
description: Generate actionable tasks from a plan.
arguments: Path to plan file
output: specs/<feature>/tasks.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Convert phases into independently testable tasks.
2. Add priority and dependency for each task.
3. Include validation step per task.
4. Save `tasks.md`.
5. Return ordered execution list.
