---
description: Create technical plan artifacts from a spec.
arguments: (optional) Path to spec directory. If omitted, reads from .ai/current.
output: specs/features/<slug>/plan.md  (or specs/bugs/<slug>/plan.md)
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Resolve spec directory: use arguments if given, otherwise read `.ai/current`.
   - If `.ai/current` is missing → stop, ask user to run `/spec` first.
2. Read `spec.md`. Check `Ready for /plan` in the Handoff block.
3. Analyze requirements and constraints.
4. Define architecture and data model notes.
5. Build phase-by-phase implementation plan with milestones and quality gates.
6. Record risks and assumptions.
7. Save `plan.md` in the same directory as `spec.md`.
8. Return plan path and phase summary.

## Rules

- Resolve from `.ai/current` when no args given.
- Keep phases small (≤5 tasks each).
- Do not invent architecture not supported by project context.
