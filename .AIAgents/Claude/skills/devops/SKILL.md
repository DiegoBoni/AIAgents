# Skill: devops

## Metadata

- Agent: Claude
- Version: 0.1.0
- Domain: devops
- Context section: `[context.devops]` in `project-context.md`

## Purpose

Handle infrastructure and delivery tasks: CI/CD pipelines, deployment config, environment management, and monitoring.
Loads only the `[context.devops]` section to minimize token usage.

## When to use

- Modifying CI/CD pipeline configuration
- Managing environment variables and secrets
- Reviewing or updating deployment scripts
- Setting up or adjusting monitoring and alerting
- Documenting rollback and incident procedures

## Context loading (minimal)

Before starting, read only:
1. `[context.devops]` section from `.AIAgents/project-context.md`
2. The specific pipeline, infra, or config file(s) involved

Do NOT load application source code, frontend components, or database migrations unless explicitly required.

## Inputs

- Task description or config file path(s) to modify
- Optional: environment name (dev / staging / prod)

## Workflow

1. Read `[context.devops]` from `.AIAgents/project-context.md`.
2. Identify the pipeline step, deployment target, or config to change.
3. Read only the relevant config or infra files.
4. Implement minimal, targeted changes following the delivery conventions.
5. Verify secrets are not hardcoded and environments are correctly scoped.
6. Return a concise summary: what changed, affected environments, and rollback steps.

## Output

- Config / pipeline / infra change(s)
- List of files modified
- Rollback instructions
- Flags for environment-specific side effects

## Constraints

- Never commit secrets or credentials — use references to the secrets manager defined in `[context.devops]`
- Changes to production pipelines require explicit confirmation before applying
- Follow the environment naming and promotion model defined in `[context.devops]`
