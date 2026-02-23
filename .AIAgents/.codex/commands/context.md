---
description: Profile the repository and generate agent context with stack, architecture, integrations, and engineering standards.
arguments: Optional focus (backend, frontend, data, testing, devops). Omit to generate all.
output: .ai/project-context.md and updated AGENTS.md notes
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

1. Scan repository files to detect languages, frameworks, package managers, and services.
2. Identify connections: databases, queues, external APIs, auth providers, cloud services.
3. Infer architecture and module boundaries from code and config.
4. Populate each `[context.<domain>]` section with only the fields relevant to that domain.
   - If a domain has no evidence in the repo, write `N/A — not detected` for each field.
   - Mark uncertain fields as `NEEDS CLARIFICATION`.
5. Write the result to `.ai/project-context.md`.
6. Update `AGENTS.md` with concise project-specific operating rules.
7. Return findings, assumptions, and gaps requiring clarification.

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

- Prefer facts from repository files over assumptions.
- Mark uncertain items as `NEEDS CLARIFICATION`.
- Keep each `[context.<domain>]` section self-contained and under ~300 words.
