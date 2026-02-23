# Skill: frontend

## Metadata

- Agent: Gemini
- Version: 0.1.0
- Domain: frontend
- Context section: `[context.frontend]` in `project-context.md`

## Purpose

Analyze, design, and review frontend changes: component structure, state management, UX flows, and API contracts.
Focused on reasoning about user experience, accessibility, and design system consistency.

## When to use

- Reviewing component architecture or state design
- Analyzing UX flows and edge cases
- Evaluating API contract usage from the UI side
- Identifying frontend risks in a proposed change
- Clarifying ambiguous UI/UX requirements before coding

## Context loading (minimal)

Before starting, read only:
1. `[context.frontend]` section from `.AIAgents/project-context.md`
2. The specific component(s), page(s), or spec relevant to the analysis

Do NOT load backend service logic, migrations, or devops sections.

## Inputs

- Description of the change, question, or artifact to review
- Optional: `specs/<feature>/spec.md` or wireframe reference

## Workflow

1. Read `[context.frontend]` from `.AIAgents/project-context.md`.
2. Read the relevant source or spec file(s).
3. Analyze the request: user journey, component boundaries, state shape, API needs.
4. Produce structured analysis: options, tradeoffs, recommendation.
5. Flag accessibility, i18n, or design system gaps.
6. Return findings with explicit confidence levels.

## Output

- Analysis memo with component structure recommendation
- UX risk list with mitigation suggestions
- Open questions marked `NEEDS CLARIFICATION`

## Constraints

- Focus on design and analysis — implementation is handled by Codex or Claude frontend skill
- Follow component and design system conventions from `[context.frontend]`
- Keep outputs actionable for the implementing agent
