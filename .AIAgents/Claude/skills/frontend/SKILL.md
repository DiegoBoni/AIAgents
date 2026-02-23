# Skill: frontend

## Metadata

- Agent: Claude
- Version: 0.1.0
- Domain: frontend
- Context section: `[context.frontend]` in `project-context.md`

## Purpose

Handle frontend implementation tasks: components, views, state, routing, styling, and API integration.
Loads only the `[context.frontend]` section to minimize token usage.

## When to use

- Building or modifying UI components or pages
- Managing client-side state or routing
- Connecting UI to backend APIs
- Applying design system or styling conventions
- Fixing accessibility or i18n issues

## Context loading (minimal)

Before starting, read only:
1. `[context.frontend]` section from `.AIAgents/project-context.md`
2. The specific component(s) or page(s) involved

Do NOT load backend service logic, migrations, or devops sections unless explicitly required.

## Inputs

- Task description or component/page path(s) to modify
- Optional: related spec file at `specs/<feature>/spec.md`

## Workflow

1. Read `[context.frontend]` from `.AIAgents/project-context.md`.
2. Identify the component, page, or state slice to change.
3. Read only the relevant source files.
4. Implement minimal, focused changes aligned with the design system and framework conventions.
5. Verify API contracts match what the backend exposes (flag mismatches, do not fix backend here).
6. Return a concise summary: what changed, why, and any follow-up needed.

## Output

- Code change(s) with inline explanation
- List of files modified
- Flags for downstream impact (API contract changes, state shape, tests)

## Constraints

- Do not modify backend or migration files in the same task
- Follow the component and styling conventions defined in `[context.frontend]`
- One component concern per task — avoid large-scope refactors mixed with features
