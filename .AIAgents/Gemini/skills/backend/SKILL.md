# Skill: backend

## Metadata

- Agent: Gemini
- Version: 0.1.0
- Domain: backend
- Context section: `[context.backend]` in `project-context.md`

## Purpose

Analyze, design, and review backend changes: API contracts, service architecture, auth flows, and integration patterns.
Focused on reasoning about correctness, tradeoffs, and risks before implementation.

## When to use

- Reviewing or designing API contracts and service boundaries
- Analyzing auth and authorization flows for correctness
- Evaluating integration patterns with external APIs
- Identifying backend risks in a proposed change
- Clarifying ambiguous backend requirements before coding

## Context loading (minimal)

Before starting, read only:
1. `[context.backend]` section from `.AIAgents/project-context.md`
2. The specific file(s) or spec relevant to the analysis

Do NOT load frontend, data migration, or devops sections unless explicitly required.

## Inputs

- Description of the change, question, or artifact to review
- Optional: `specs/<feature>/spec.md` or `plan.md`

## Workflow

1. Read `[context.backend]` from `.AIAgents/project-context.md`.
2. Read the relevant source or spec file(s).
3. Analyze the request: identify assumptions, constraints, and risks.
4. Produce structured analysis: options, tradeoffs, recommendation.
5. Flag open questions that require clarification before implementation.
6. Return findings with explicit confidence levels.

## Output

- Analysis memo with options and recommendation
- Risk list with mitigation suggestions
- Open questions marked `NEEDS CLARIFICATION`

## Constraints

- Focus on design and analysis — implementation is handled by Codex or Claude backend skill
- Follow auth and API conventions from `[context.backend]`
- Keep outputs actionable for the implementing agent
