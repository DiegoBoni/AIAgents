# Skill: backend

## Metadata

- Agent: Codex
- Version: 0.1.0
- Domain: backend
- Context section: `[context.backend]` in `project-context.md`

## Purpose

Implement backend code changes: endpoints, services, business logic, auth, and integrations.
Focused on producing working, testable code with minimal context overhead.

## When to use

- Implementing or modifying API endpoints
- Writing or refactoring services and business logic
- Integrating external APIs
- Adding middleware, validation, or error handling
- Fixing backend bugs

## Context loading (minimal)

Before starting, read only:
1. `[context.backend]` section from `.AIAgents/project-context.md`
2. The specific file(s) to modify

Do NOT load frontend, data migration, or devops sections.

## Inputs

- File path(s) and description of the change
- Optional: `specs/<feature>/tasks.md` for the current task

## Workflow

1. Read `[context.backend]` from `.AIAgents/project-context.md`.
2. Read the target file(s).
3. Implement the change following framework conventions and coding standards.
4. Ensure input validation, error handling, and auth guards are present.
5. Run lint and unit tests if available.
6. Return: files changed, behavioral impact, downstream flags (data layer, API contract).

## Output

- Code implementation
- List of files modified
- Lint/test result summary
- Flags for contract changes affecting frontend or data

## Constraints

- Do not modify frontend or migration files in the same task
- Follow auth strategy from `[context.backend]`
- One concern per task — no mixed refactor + feature work
