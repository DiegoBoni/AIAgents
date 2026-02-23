---
description: Build a structured project profile to guide agent behavior across product and engineering tasks.
arguments: Optional scope (product, backend, frontend, data)
output: .AIAgents/project-context.md and updated GEMINI.md notes
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Inspect repository metadata and source layout.
2. Document stack, architecture, integrations, and delivery workflow.
3. Capture coding standards, testing approach, and release conventions.
4. Create `.AIAgents/project-context.md` from template.
5. Update `GEMINI.md` with project-aware guardrails.
6. Return unresolved ambiguities as `NEEDS CLARIFICATION`.

## Rules

- Keep language clear for technical and product stakeholders.
- Do not invent technologies not found in repo evidence.
- Make outputs reusable across future tasks.
