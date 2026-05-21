# Gemini Instructions

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
2. `/spec`       → define feature requirements — Gemini excels here (creates .ai/current automatically)
3. `/plan`       → architecture + phased implementation plan (reads .ai/current automatically)
4. `/tasks`      → execution task list — Gemini surfaces sequencing risks
5. `/implement`  → readiness review before handing off to Claude or Codex
6. `/review`     → deep gap analysis between spec intent and implementation — Gemini's strength
7. `/skill`      → create or edit a project-specific analysis skill

Navigation:
- `/status`      → pipeline snapshot with risk assessment
- `/switch`      → change active spec; highlights outstanding review issues on switch
- `/fix`         → root cause analysis + recommendation; add --trace for bug specs

Multi-agent workflow:
- Spec phase (/spec) → Gemini preferred — surfaces hidden requirements and risks
- Implementation review (/implement) → Gemini validates readiness, hands off to Claude/Codex
- Code review (/review) → Gemini's core strength — behavioral drift, edge case gaps
- Shared artifact: specs/<type>/<slug>/ — any agent picks up via .ai/current

Bootstrap command:
`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy`
<!-- .AIAgents Autoload End -->
