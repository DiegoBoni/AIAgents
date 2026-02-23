# Skill: devops

## Metadata

- Agent: Gemini
- Version: 0.1.0
- Domain: devops
- Context section: `[context.devops]` in `project-context.md`

## Purpose

Analyze and design infrastructure and delivery changes: pipeline architecture, deployment strategy, environment configuration, and incident response.
Focused on reasoning about reliability, security, and blast radius before implementation.

## When to use

- Reviewing or designing CI/CD pipeline architecture
- Analyzing deployment strategy and rollback options
- Evaluating secrets and environment management approach
- Assessing blast radius of a proposed infra change
- Clarifying delivery requirements before coding

## Context loading (minimal)

Before starting, read only:
1. `[context.devops]` section from `.AIAgents/project-context.md`
2. The specific pipeline or infra file(s) relevant to the analysis

Do NOT load application source code, frontend components, or migrations.

## Inputs

- Description of the change, question, or artifact to review
- Optional: target environment (dev / staging / prod)

## Workflow

1. Read `[context.devops]` from `.AIAgents/project-context.md`.
2. Read the relevant config or pipeline file(s).
3. Analyze: reliability impact, security posture, environment scope, rollback viability.
4. Produce structured analysis: options, tradeoffs, recommendation.
5. Flag production-affecting changes that need explicit approval.
6. Return findings with explicit confidence levels.

## Output

- Infra / pipeline design recommendation
- Risk list: reliability, security, blast radius
- Open questions marked `NEEDS CLARIFICATION`

## Constraints

- Focus on design and analysis — implementation is handled by Codex or Claude devops skill
- Follow environment naming and secrets conventions from `[context.devops]`
- Always assess blast radius — production changes flagged explicitly
