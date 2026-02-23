# Skill: data

## Metadata

- Agent: Codex
- Version: 0.1.0
- Domain: data
- Context section: `[context.data]` in `project-context.md`

## Purpose

Implement data layer changes: migrations, model updates, query optimization, and caching.
Focused on safe, reversible changes with clear rollback paths.

## When to use

- Writing or modifying database migrations
- Updating ORM models or entity definitions
- Optimizing queries
- Adding indexes, constraints, or defaults
- Configuring caching

## Context loading (minimal)

Before starting, read only:
1. `[context.data]` section from `.AIAgents/project-context.md`
2. The specific migration, model, or query file(s) to modify

Do NOT load frontend components, backend service logic, or devops sections.

## Inputs

- File path(s) and description of the change
- Optional: target environment (dev / staging / prod)

## Workflow

1. Read `[context.data]` from `.AIAgents/project-context.md`.
2. Read the target file(s).
3. Implement the change following migration conventions and naming standards.
4. Check for data integrity: constraints, indexes, nullability, defaults.
5. Add rollback instructions for destructive operations.
6. Return: files changed, migration steps, rollback notes, upstream impact flags.

## Output

- Migration / model / query implementation
- List of files modified
- Rollback instructions
- Flags for backend model or seed data impact

## Constraints

- Never drop columns or tables without explicit confirmation
- Follow migration strategy from `[context.data]`
- Keep migrations reversible unless explicitly marked destructive
