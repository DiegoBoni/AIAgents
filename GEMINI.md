# Gemini Instructions

Load command files from `.AIAgents/.gemini/commands/*.md`.

<!-- .AIAgents Autoload Start -->
Load command files from .gemini/commands/*.md

Domain skills available (load only the skill for your current task):
- .gemini/skills/backend/SKILL.md
- .gemini/skills/frontend/SKILL.md
- .gemini/skills/data/SKILL.md
- .gemini/skills/testing/SKILL.md
- .gemini/skills/devops/SKILL.md

Startup behavior (required):
1. Run `/scan` first to create/update `.ai/project-context.md`.
2. If `project-context.md` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the skill matching your domain (backend, frontend, data, testing, devops).
4. Each skill specifies exactly which section of `project-context.md` to read — load only that section.
5. If critical info is missing, mark `NEEDS CLARIFICATION` and continue with safe defaults.

Recommended execution order:
1. `/scan`       → populate .ai/project-context.md
2. `/spec`       → define feature requirements (Gemini excels here — analysis and requirements)
3. `/plan`       → architecture + phased implementation plan
4. `/tasks`      → execution task list with dependencies
5. `/implement`  → readiness review before handing off to Claude or Codex
6. `/skill`      → create or edit a project-specific analysis skill

Multi-agent workflow:
- Spec phase (/spec) → Gemini preferred (strong requirements analysis)
- Implementation phase (/implement) → Gemini runs readiness review, then hands off to Claude/Codex
- Shared artifact: specs/<feature>/ — any agent can hand off to another via these files

Bootstrap command:
`./.AIAgents/scripts/bootstrap-commands.sh --repo /Users/boni/Documents/New project --agent all --mode copy`
<!-- .AIAgents Autoload End -->
