# Skill: data

## Metadata

- Agent: Claude
- Version: 0.1.0
- Domain: data
- Context section: `[context.data]` in `project-context.md`

## Purpose

Handle data layer tasks: schema design, migrations, query optimization, model changes, and caching.
Loads only the `[context.data]` section to minimize token usage.

## When to use

- Designing or modifying database schemas
- Writing or reviewing migrations
- Optimizing slow queries
- Adding or changing ORM models / entities
- Configuring caching strategy
- Reviewing data validation rules

## Context loading (minimal)

Before starting, read only:
1. `[context.data]` section from `.AIAgents/project-context.md`
2. The specific migration file(s), model(s), or query file(s) involved

Do NOT load frontend components, backend service logic, or devops sections unless explicitly required.

## Inputs

- Task description or file path(s) to modify
- Optional: related spec or ERD reference

## Workflow

1. Read `[context.data]` from `.AIAgents/project-context.md`.
2. Identify the schema, model, or query to change.
3. Read only the relevant source files.
4. Implement changes following the migration strategy and naming conventions.
5. Verify data integrity: constraints, indexes, nullability, defaults.
6. Flag any breaking changes that require backend or seed data updates.
7. Return a concise summary: what changed, migration steps, and rollback notes.

## Output

- Schema / migration / model change(s)
- List of files modified
- Rollback instructions if destructive
- Flags for upstream impact (backend models, API contracts, seed data)

## Constraints

- Never drop columns or tables without explicit confirmation
- Follow the migration strategy defined in `[context.data]`
- Keep migrations reversible unless documented as intentionally destructive
