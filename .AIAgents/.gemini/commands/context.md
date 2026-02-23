---
description: Build a structured project profile to guide agent behavior across product and engineering tasks.
arguments: Optional scope (backend, frontend, data, testing, devops). Omit to generate all.
output: .ai/project-context.md and updated GEMINI.md notes
---

## User Input

```text
$ARGUMENTS
```

## Goal

Produce an accurate, evidence-based project context that domain skills can load in full or in part.
Each `[context.<domain>]` section must be self-contained so a skill can load only its section
without needing the rest of the file.

## Steps

1. Inspect repository metadata and source layout.
2. Document stack, architecture, integrations, and delivery workflow.
3. Capture coding standards, testing approach, and release conventions.
4. Populate each `[context.<domain>]` section with only the fields relevant to that domain.
   - If a domain has no evidence in the repo, write `N/A — not detected` for each field.
   - Mark uncertain fields as `NEEDS CLARIFICATION`.
5. Write the result to `.ai/project-context.md`.
6. Update `GEMINI.md` with project-aware guardrails.
7. Return unresolved ambiguities as `NEEDS CLARIFICATION`.

## Domain skill mapping

After running this command, each skill loads only its section:

| Skill    | Reads from project-context.md |
|----------|-------------------------------|
| backend  | `[context.backend]`           |
| frontend | `[context.frontend]`          |
| data     | `[context.data]`              |
| testing  | `[context.testing]`           |
| devops   | `[context.devops]`            |

## Rules

- Keep language clear for technical and product stakeholders.
- Do not invent technologies not found in repo evidence.
- Keep each `[context.<domain>]` section self-contained and under ~300 words.
- Make outputs reusable across future tasks.
