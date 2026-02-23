# Claude Instructions

Load command files from `.claude/commands/*.md`.

<!-- .AIAgents Autoload Start -->
Load command files from .claude/commands/*.md

Domain skills available (load only the skill for your current task):
- .claude/skills/backend/SKILL.md
- .claude/skills/frontend/SKILL.md
- .claude/skills/data/SKILL.md
- .claude/skills/testing/SKILL.md
- .claude/skills/devops/SKILL.md

Startup behavior (required):
1. Run `/context` first to create/update `.ai/project-context.md`.
2. If `project-context.md` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the skill matching your domain (backend, frontend, data, testing, devops).
4. Each skill specifies exactly which section of `project-context.md` to read — load only that section.
5. If critical info is missing, mark `NEEDS CLARIFICATION` and continue with safe defaults.

Recommended execution order:
1. `/context`
2. `/spec`
3. `/plan`
4. `/tasks`

Bootstrap command:
`./.AIAgents/scripts/bootstrap-commands.sh --repo /Users/boni/Documents/New project --agent all --mode copy`
<!-- .AIAgents Autoload End -->
