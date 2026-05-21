---
description: Produce a delivery plan from a feature or bug spec.
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
2. Read `spec.md`. Verify `Ready for /plan: yes` in Handoff block.
3. Translate requirements into implementation phases with dependency mapping.
4. Add timeline estimates and risk controls.
5. Save `plan.md` in the same directory as `spec.md`.
6. Return milestone summary and critical blockers.

## Rules

- Resolve from `.ai/current` when no args given.
- Surface risks clearly — Gemini's value here is identifying hidden dependencies.
- Do not make implementation decisions beyond what the spec supports.
