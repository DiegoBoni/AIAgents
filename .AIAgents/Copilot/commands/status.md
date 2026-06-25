---
description: Show the current pipeline state — active spec, stage, task progress, and next step.
arguments: none
output: Pipeline snapshot in chat
usage: Paste this prompt into Copilot Chat
---

## Prompt

Show the current pipeline status.

Steps:
1. Read `.ai/current` to find the active spec directory.
2. Read `spec.md` — extract title and Handoff block.
3. Read `plan.md` if it exists — extract phase count.
4. Read `tasks.md` if it exists — count todo / in-progress / done / blocked tasks.
5. Determine current stage: spec → plan → tasks → implement → done.
6. Return a concise snapshot:
   - Active spec and path
   - Current stage
   - Task progress (e.g. 3/10 done, 1 blocked)
   - Recommended next step

Rules:
- Read only, no file writes.
- If `.ai/current` is missing, report "No active spec — run scan and spec first."
