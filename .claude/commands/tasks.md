---
description: Build execution tasks from the implementation plan.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: specs/features/<slug>/tasks.md  (or specs/bugs/<slug>/tasks.md)
---

## User Input

```text
$ARGUMENTS
```

## Resolving the spec

1. If arguments provided → use as spec directory.
2. If no arguments → read `.ai/current`.
3. If `.ai/current` is missing → stop, ask user to run `/spec` first.
4. Read `plan.md` from the resolved directory. If missing → ask user to run `/plan` first.

## Steps

1. Resolve spec directory as above.
2. Read `plan.md` and convert each phase's milestones into atomic tasks.
3. For each task assign:
   - **Domain**: backend | frontend | data | testing | devops
   - **Dependencies**: task IDs that must complete first (empty = can start immediately)
   - **Validation**: concrete check that confirms the task is done
   - **Parallel**: yes | no (can it run alongside other domain tasks?)
4. Save `tasks.md` in the same directory as `spec.md` and `plan.md`.
5. Return: critical path + tasks grouped by domain + parallelizable batches.

## Output format (tasks.md)

```markdown
# Tasks: <Feature or Bug Name>
<!-- spec: <path> -->
<!-- plan: <path> -->
<!-- created: <YYYY-MM-DD> -->

## Critical path
T01 → T03 → T05 → T07

## Tasks

### T01 — <task name>
- Domain: backend
- Depends on: —
- Parallel: yes
- Validation: <concrete check>

### T02 — <task name>
- Domain: data
- Depends on: —
- Parallel: yes
- Validation: <concrete check>

### T03 — <task name>
- Domain: backend
- Depends on: T01, T02
- Parallel: no
- Validation: <concrete check>
```

## Rules

- Resolve from `.ai/current` when no args given
- Each task must have exactly one domain — split cross-domain work into separate tasks
- Validation must be concrete and independently verifiable
- Tasks with no dependencies and different domains are candidates for parallel sub-agents in `/implement`
