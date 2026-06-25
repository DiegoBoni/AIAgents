---
description: Build an atomic execution task list from the implementation plan.
arguments: Optional path to spec directory. If omitted, reads from .ai/current.
output: specs/<type>/<slug>/tasks.md
usage: Paste this prompt into Copilot Chat
---

## Prompt

Build a task list from the current implementation plan.

Steps:
1. Read `.ai/current` to get the spec directory.
2. Read `plan.md`.
3. Break each phase into atomic tasks (one file or one concern per task).
4. For each task record: id, title, domain (backend/frontend/data/testing/devops), depends-on, status (todo).
5. Save `tasks.md` in the same directory.
6. Return task count per domain and the critical path.

Rules:
- Tasks must be independently executable — no hidden dependencies.
- Domain assignment determines which skill to load when executing.
- Do not merge tasks across domains.
