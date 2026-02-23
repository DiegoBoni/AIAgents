# Skill: testing

## Metadata

- Agent: Claude
- Version: 0.1.0
- Domain: testing
- Context section: `[context.testing]` in `project-context.md`

## Purpose

Handle test authoring and review tasks: unit tests, integration tests, E2E scenarios, and coverage gaps.
Loads only the `[context.testing]` section plus the files under test to minimize token usage.

## When to use

- Writing unit tests for new or modified functions
- Adding integration tests for API endpoints or services
- Setting up or extending E2E test scenarios
- Reviewing test coverage and identifying gaps
- Fixing broken or flaky tests

## Context loading (minimal)

Before starting, read only:
1. `[context.testing]` section from `.AIAgents/project-context.md`
2. The specific source file(s) being tested
3. Existing test file(s) for that unit if they exist

Do NOT load unrelated backend services, frontend components, or devops config unless required.

## Inputs

- Source file path(s) to test
- Optional: description of the scenario or bug to cover

## Workflow

1. Read `[context.testing]` from `.AIAgents/project-context.md`.
2. Read the source file(s) to understand inputs, outputs, and edge cases.
3. Read existing test file(s) to avoid duplication.
4. Write focused, deterministic tests covering happy path and key edge cases.
5. Verify tests are isolated: no shared mutable state, no network calls unless integration test.
6. Return summary: tests added, coverage intent, and any gaps left open.

## Output

- Test file(s) with new or updated test cases
- List of files modified
- Coverage notes: what is tested and what is explicitly left out

## Constraints

- Unit tests must not make real network or database calls
- Follow the test framework and naming conventions in `[context.testing]`
- Do not modify source files to make them easier to test — flag instead
