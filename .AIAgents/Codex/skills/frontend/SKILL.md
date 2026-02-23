# Skill: frontend

## Metadata

- Agent: Codex
- Version: 0.1.0
- Domain: frontend
- Context section: `[context.frontend]` in `project-context.md`

## Purpose

Implement frontend code changes: components, pages, state, routing, and API integration.
Focused on producing working UI code aligned with the design system.

## When to use

- Building or modifying components or pages
- Wiring state management or routing
- Connecting UI to backend APIs
- Applying design system tokens and styling conventions
- Fixing UI bugs or accessibility issues

## Context loading (minimal)

Before starting, read only:
1. `[context.frontend]` section from `.AIAgents/project-context.md`
2. The specific component(s) or page(s) to modify

Do NOT load backend service logic, migrations, or devops sections.

## Inputs

- Component/page path(s) and description of the change
- Optional: `specs/<feature>/tasks.md` for the current task

## Workflow

1. Read `[context.frontend]` from `.AIAgents/project-context.md`.
2. Read the target file(s).
3. Implement the change using the established component patterns and design system.
4. Verify API calls match the backend contract — flag mismatches, do not fix backend here.
5. Run lint if available.
6. Return: files changed, behavioral impact, downstream flags.

## Output

- Code implementation
- List of files modified
- Flags for API contract mismatches or state shape changes

## Constraints

- Do not modify backend or migration files in the same task
- Follow component and styling conventions from `[context.frontend]`
- One component concern per task
