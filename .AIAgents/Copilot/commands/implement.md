---
description: Execute tasks from the task list, domain by domain.
arguments: Optional domain filter (backend|frontend|data|testing|devops) or task id.
output: Code changes + updated task statuses in tasks.md
usage: Paste this prompt into Copilot Chat. Load the matching domain skill first.
---

## Prompt

Execute the next pending task(s) from the current task list.

Steps:
1. Read `.ai/current` to get the spec directory.
2. Read `tasks.md`. Identify the next todo task(s) — respect depends-on ordering.
3. Load the domain skill for the task's domain from `.copilot/skills/<domain>/SKILL.md`.
4. Read only the matching `[context.<domain>]` section from `.ai/project-context.md`.
5. Implement the task following the skill workflow.
6. Mark the task as `done` in `tasks.md`.
7. Return: task completed, files changed, flags for downstream tasks.

Rules:
- Execute one domain at a time — do not mix backend and frontend in the same step.
- Load only the skill and context section matching the current task's domain.
- If a task is blocked, mark it `blocked` with a reason and move to the next.
