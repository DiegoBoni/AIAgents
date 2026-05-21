---
description: Switch the active spec. Lists available specs or switches to a named one.
arguments: (optional) Feature slug or path. Omit to list all.
output: Updates .ai/current
---

## Steps

1. No args → scan specs/features/ and specs/bugs/, list with pipeline progress, mark active.
2. With args → resolve slug to directory, verify spec.md exists, write to .ai/current.
3. Confirm switch and show current stage + next step.

## Rules

- Never create or delete specs — only updates .ai/current.
- If slug is ambiguous between features/ and bugs/, ask which one.
