---
description: Create or update a domain skill focused on analysis and requirements validation for this project.
arguments: Skill name and domain. Example: "checkout-flow frontend"
output: .gemini/skills/<name>/SKILL.md
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Parse skill name and domain from arguments.
2. Check if `.gemini/skills/<name>/SKILL.md` exists — update if so, create if not.
3. Read `[context.<domain>]` from `.ai/project-context.md`.
4. Extract product and architectural context relevant to this skill.
5. Write the skill focused on analysis and review:
   - What decisions this skill evaluates
   - Risk signals specific to this project's architecture
   - Review checklist items derived from engineering standards
   - Handoff criteria for passing work to implementation agents
6. Save to `.gemini/skills/<name>/SKILL.md`.

## Rules

- Analysis-focused — do not include code generation steps.
- Every checklist item must be grounded in this project's actual standards.
- If context is missing or ambiguous, surface it as `NEEDS CLARIFICATION` — do not assume.
