---
description: Execute implementation tasks from a feature's task list, domain-by-domain, with progress tracking and optional sub-agent parallelism.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: Implemented code changes + progress report
---

## User Input

```text
$ARGUMENTS
```

## Resolving the spec

1. If arguments provided → use as spec directory.
2. If no arguments → read `.ai/current`.
3. If `.ai/current` is missing → stop, ask user to run `/spec` first.
4. Read `tasks.md` from the resolved directory. If missing → ask user to run `/tasks` first.
5. Read `plan.md` for quality gates and architectural constraints.

## Steps

1. Resolve spec directory as above.
2. Read `tasks.md` and group tasks by domain: `backend`, `frontend`, `data`, `testing`, `devops`.
3. Register all tasks in TodoWrite (status: pending) before starting any work.
4. Determine execution order from dependency graph:
   - Tasks with no dependencies and different domains → candidate for parallel sub-agents.
   - Tasks with declared dependencies → execute in dependency order.
5. For each task (or domain batch):
   a. Mark task as `in_progress` in TodoWrite.
   b. Load `.claude/skills/<domain>/SKILL.md`.
   c. Read only `[context.<domain>]` from `.ai/project-context.md`.
   d. Implement the minimum change that satisfies the task's validation criteria.
   e. Mark task as `done` in TodoWrite immediately on completion.
   f. Log cross-domain impacts as follow-up items — do NOT resolve them in the same task.
6. After all tasks: emit the final report.

## Harness Integration (sub-agents)

When tasks in different domains have no dependencies between them:
- Spawn one sub-agent per domain group via the Agent tool.
- Each sub-agent receives:
  - The task list for its domain
  - Path to its domain skill: `.claude/skills/<domain>/SKILL.md`
  - The matching context section: `[context.<domain>]` from `.ai/project-context.md`
  - The spec file for reference: `spec.md` from the resolved directory
- Collect sub-agent results and merge before reporting.

## Output

```
## Implementation Report — <feature>

### Completed tasks
- [domain] T01: Task description → files changed

### Blocked tasks
- T05: reason

### Cross-domain flags
- [backend → frontend] What needs follow-up

### Quality gates
- Gate name: Pass | Fail
```

## Rules

- Resolve from `.ai/current` when no args given
- Never load the full `project-context.md` — only the matching `[context.<domain>]` section
- Never implement cross-domain impacts in the same task — flag them
- Mark TodoWrite tasks in real time — not at the end
- One concern per task — no feature + fix + refactor in a single step
