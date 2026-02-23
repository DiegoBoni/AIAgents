# Skill: testing

## Metadata

- Agent: Codex
- Version: 0.1.0
- Domain: testing
- Context section: `[context.testing]` in `project-context.md`

## Purpose

Write and fix tests: unit, integration, and E2E.
Focused on deterministic, isolated test cases with clear coverage intent.

## When to use

- Writing unit tests for new or changed functions
- Adding integration tests for endpoints or services
- Extending E2E scenarios
- Fixing broken or flaky tests
- Identifying coverage gaps

## Context loading (minimal)

Before starting, read only:
1. `[context.testing]` section from `.AIAgents/project-context.md`
2. The source file(s) under test
3. Existing test file(s) for those units

Do NOT load unrelated backend services, frontend components, or devops config.

## Inputs

- Source file path(s) to test
- Optional: scenario or bug description to cover

## Workflow

1. Read `[context.testing]` from `.AIAgents/project-context.md`.
2. Read source and existing test files.
3. Write focused tests: happy path + key edge cases.
4. Ensure isolation: no shared mutable state, no real network/DB calls in unit tests.
5. Run tests and report results.
6. Return: tests added, coverage intent, gaps left open.

## Output

- Test file(s) with new or updated cases
- Test run results
- Coverage notes

## Constraints

- Unit tests must not make real network or database calls
- Follow test framework and naming from `[context.testing]`
- Do not modify source files to make them easier to test — flag instead
