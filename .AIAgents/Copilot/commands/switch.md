---
description: Switch the active spec without re-running spec. Lists available specs or switches to a named one.
arguments: Optional spec slug or path. If omitted, lists available specs.
output: Updated .ai/current
usage: Paste this prompt into Copilot Chat, replacing <SLUG> with the spec name or leaving blank to list
---

## Prompt

Switch active spec to: <SLUG>  (leave blank to list all available specs)

Steps:
1. If no slug given: list all directories under `specs/features/` and `specs/bugs/` with their titles from `spec.md`. Stop here.
2. If slug given: resolve the full path (`specs/features/<slug>` or `specs/bugs/<slug>`).
3. Verify `spec.md` exists in that directory.
4. Write the resolved path to `.ai/current` (overwrite).
5. Return the new active spec title and current stage (check for plan.md / tasks.md presence).

Rules:
- Do not modify any spec files — only update `.ai/current`.
- If the slug is ambiguous (matches both features and bugs), ask the user to clarify.
