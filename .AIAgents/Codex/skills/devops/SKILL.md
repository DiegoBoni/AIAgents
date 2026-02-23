# Skill: devops

## Metadata

- Agent: Codex
- Version: 0.1.0
- Domain: devops
- Context section: `[context.devops]` in `project-context.md`

## Purpose

Implement CI/CD and infrastructure changes: pipeline config, deployment scripts, environment management.
Focused on safe, scoped changes with clear environment impact.

## When to use

- Modifying CI/CD pipeline steps
- Updating deployment scripts or Dockerfiles
- Managing environment variables and secrets references
- Adjusting build or release configuration
- Fixing broken pipeline steps

## Context loading (minimal)

Before starting, read only:
1. `[context.devops]` section from `.AIAgents/project-context.md`
2. The specific pipeline or config file(s) to modify

Do NOT load application source code, frontend components, or database migrations.

## Inputs

- Config file path(s) and description of the change
- Optional: target environment (dev / staging / prod)

## Workflow

1. Read `[context.devops]` from `.AIAgents/project-context.md`.
2. Read the target config file(s).
3. Implement the change following the pipeline and environment conventions.
4. Verify no secrets are hardcoded — use references to the secrets manager.
5. Return: files changed, affected environments, rollback steps.

## Output

- Pipeline / config / infra implementation
- List of files modified
- Rollback instructions
- Environment impact notes

## Constraints

- Never hardcode secrets — reference the secrets manager from `[context.devops]`
- Production pipeline changes require explicit confirmation before applying
- Follow environment naming from `[context.devops]`
