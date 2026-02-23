# Skill: testing

## Metadata

- Agent: Gemini
- Version: 0.1.0
- Domain: testing
- Context section: `[context.testing]` in `project-context.md`

## Purpose

Analyze test coverage, design test strategies, and identify gaps.
Focused on reasoning about what needs to be tested and how, before writing test code.

## When to use

- Designing a test strategy for a new feature
- Reviewing test coverage and identifying gaps
- Analyzing flaky or failing tests for root cause
- Recommending E2E scenarios based on user flows
- Clarifying testing requirements before implementation

## Context loading (minimal)

Before starting, read only:
1. `[context.testing]` section from `.AIAgents/project-context.md`
2. The source file(s) and existing test file(s) relevant to the analysis

Do NOT load unrelated services, frontend components, or devops config.

## Inputs

- Source file(s) or feature description to analyze
- Optional: CI failure logs or coverage report

## Workflow

1. Read `[context.testing]` from `.AIAgents/project-context.md`.
2. Read source and existing test files.
3. Map user flows and edge cases to test scenarios.
4. Identify: missing coverage, test isolation issues, flakiness risks.
5. Produce a prioritized list of tests to write.
6. Return findings with explicit confidence levels.

## Output

- Test strategy memo with prioritized scenarios
- Coverage gap analysis
- Open questions marked `NEEDS CLARIFICATION`

## Constraints

- Focus on strategy and analysis — writing test code is handled by Codex or Claude testing skill
- Follow test framework conventions from `[context.testing]`
- Prioritize tests by risk and user impact
