---
name: switch
description: Switch the active spec without running spec again. Lists available specs or switches to a named one. Updates .ai/current.
---

# Switch

## Arguments

Optional feature slug or path. Omit to list all available specs.

## Output

Updates `.ai/current` + confirmation message.

## Goal

Change which spec is active — useful when working on multiple features in parallel
or resuming work on a spec created earlier.

## Steps

### No arguments — list mode

1. Scan `specs/features/` and `specs/bugs/` for directories containing a `spec.md`.
2. For each spec, read the frontmatter to get: name, type, created date.
3. Mark the currently active spec (from `.ai/current`) with `←`.
4. Show pipeline progress per spec (which of spec/plan/tasks/review exist).
5. Prompt the user to choose one, or pass the slug as argument to switch.

### With argument — switch mode

1. Resolve the target:
   - If argument matches a slug exactly → check `specs/features/<slug>/` then `specs/bugs/<slug>/`.
   - If argument includes `features/` or `bugs/` prefix → use directly.
   - If not found → list available specs and ask again.
2. Verify `spec.md` exists in the target directory.
3. Write the resolved path (e.g. `specs/features/checkout-flow`) to `.ai/current`.
4. Read the spec's name and stage, confirm the switch.

## Output — list mode

```
Available specs:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 features/
   checkout-flow       [spec ✓ plan ✓ tasks ✓ review –]  ← active
   user-auth           [spec ✓ plan ✓ tasks – review –]
   dashboard-v2        [spec ✓ plan – tasks – review –]

 bugs/
   payment-safari      [spec ✓ plan – tasks – review –]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Run: switch user-auth
```

## Output — switch mode

```
Switched active spec:
  from: specs/features/checkout-flow
  to:   specs/features/user-auth

Stage: plan  (tasks not yet generated)
Next step: tasks
```

## Rules

- Never create or delete specs — read-only except for `.ai/current`
- If the argument is ambiguous (slug exists in both features/ and bugs/), ask which one
- Always show the current stage after switching so the user knows where to resume
