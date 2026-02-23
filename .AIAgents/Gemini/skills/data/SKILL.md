# Skill: data

## Metadata

- Agent: Gemini
- Version: 0.1.0
- Domain: data
- Context section: `[context.data]` in `project-context.md`

## Purpose

Analyze and design data layer changes: schema decisions, migration strategy, query patterns, and data integrity.
Focused on reasoning about correctness, performance, and safety before implementation.

## When to use

- Designing or reviewing schema changes
- Evaluating migration strategy and risk
- Analyzing query patterns for correctness and performance
- Reviewing data model decisions and entity relationships
- Clarifying data requirements before coding

## Context loading (minimal)

Before starting, read only:
1. `[context.data]` section from `.AIAgents/project-context.md`
2. The specific schema, model, or migration file(s) relevant to the analysis

Do NOT load frontend, backend service logic, or devops sections.

## Inputs

- Description of the change, question, or artifact to review
- Optional: ERD reference or existing migration files

## Workflow

1. Read `[context.data]` from `.AIAgents/project-context.md`.
2. Read the relevant schema or migration file(s).
3. Analyze: data integrity, index strategy, migration reversibility, performance impact.
4. Produce structured analysis: options, tradeoffs, recommendation.
5. Flag breaking changes that require coordinated backend or seed data updates.
6. Return findings with explicit confidence levels.

## Output

- Schema / migration design recommendation
- Risk list: integrity, performance, reversibility
- Open questions marked `NEEDS CLARIFICATION`

## Constraints

- Focus on design and analysis — implementation is handled by Codex or Claude data skill
- Follow migration conventions from `[context.data]`
- Always assess reversibility — flag irreversible operations explicitly
