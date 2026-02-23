---
description: Profile the repository and generate agent context with stack, architecture, integrations, and engineering standards.
arguments: Optional focus (e.g. backend, frontend, infra)
output: .AIAgents/project-context.md and updated AGENTS.md notes
---

## User Input

```text
$ARGUMENTS
```

## Steps

1. Scan repository files to detect languages, frameworks, package managers, and services.
2. Identify connections: databases, queues, external APIs, auth providers, cloud services.
3. Infer architecture and module boundaries from code and config.
4. Generate `.AIAgents/project-context.md` using the shared template.
5. Update `AGENTS.md` with concise project-specific operating rules.
6. Return findings, assumptions, and gaps requiring clarification.

## Rules

- Prefer facts from repository files over assumptions.
- Mark uncertain items as `NEEDS CLARIFICATION`.
- Keep context concise and actionable.
