---
description: Scan the repository and generate the full project context plus domain-specific context sections.
arguments: Optional domain focus (backend, frontend, data, testing, devops). Omit to generate all.
output: .ai/project-context.md — with populated [context.<domain>] sections
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

1. Scan repository structure: directories, config files, package manifests, CI files, README.
2. Extract per-domain evidence:
   - **backend**: language, framework, entry points, service modules, auth, external APIs, error handling, logging.
   - **frontend**: framework, state management, routing, component library, API layer, styling, build tooling.
   - **data**: databases, ORM/query layer, migration files, key models, caching, validation.
   - **testing**: test frameworks, test file patterns, coverage config, CI test gates.
   - **devops**: cloud provider, CI/CD platform, deployment scripts, environment names, secrets references, monitoring.
3. Populate the top-level sections (Metadata, Stack, Architecture, Engineering Standards, Agent Instructions).
4. Populate each `[context.<domain>]` section with only the fields relevant to that domain.
   - If a domain has no evidence in the repo, write `N/A — not detected` for each field.
   - Mark uncertain fields as `NEEDS CLARIFICATION`.
5. Write the result to `.ai/project-context.md`.
6. Update `CLAUDE.md` with any project-specific constraints discovered (path reference: `.claude/commands/*.md`).
7. Return:
   - Confidence level per domain (high / medium / low)
   - List of assumptions made
   - Open questions marked `NEEDS CLARIFICATION`

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

- Prefer repository evidence over assumptions.
- Keep each `[context.<domain>]` section self-contained and under ~300 words.
- Do not repeat information across sections — cross-reference instead.
- Mark all assumptions explicitly.
- Re-run this command (or target a specific domain) whenever the stack changes.
