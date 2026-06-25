---
description: Profile the repository and generate agent context with stack, architecture, integrations, and engineering standards.
arguments: Optional focus (e.g. backend, frontend, infra)
output: .ai/project-context.md
usage: Paste this prompt into Copilot Chat
---

## Prompt

Scan this repository and generate `.ai/project-context.md`.

Steps:
1. Detect languages, frameworks, package managers, and services from repository files.
2. Identify connections: databases, queues, external APIs, auth providers, cloud services.
3. Infer architecture and module boundaries from code and config.
4. Write `.ai/project-context.md` with sections: `[context.backend]`, `[context.frontend]`, `[context.data]`, `[context.testing]`, `[context.devops]`.
5. Return a summary of findings and any items marked `NEEDS CLARIFICATION`.

Rules:
- Prefer facts from files over assumptions.
- Mark uncertain items as `NEEDS CLARIFICATION`.
- Keep context concise and actionable.
