---
description: Create a technical implementation plan from the active spec.
arguments: Optional path to spec directory. If omitted, reads from .ai/current.
output: specs/<type>/<slug>/plan.md
usage: Paste this prompt into Copilot Chat
---

## Prompt

Create a technical plan for the current spec.

Steps:
1. Read `.ai/current` to get the spec directory. If missing, stop and ask the user to run scan first.
2. Read `spec.md`. Check that `Ready for plan: yes` in the Handoff block.
3. Analyze requirements and project constraints.
4. Define architecture notes and any data model changes needed.
5. Write a phase-by-phase implementation plan with milestones and quality gates.
6. Record risks and open assumptions.
7. Save `plan.md` in the same directory as `spec.md`.
8. Return the plan path and a phase summary.

Rules:
- Keep phases small (5 tasks or fewer each).
- Do not invent architecture not supported by `.ai/project-context.md`.
- Flag blocking open questions rather than guessing.
