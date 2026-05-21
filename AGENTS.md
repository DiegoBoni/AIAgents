# AGENTS Instructions

<!-- .AIAgents Autoload Start -->
Load command files from .codex/commands/*.md

Domain skills available (load only the skill for your current task):
- .codex/skills/backend/SKILL.md
- .codex/skills/frontend/SKILL.md
- .codex/skills/data/SKILL.md
- .codex/skills/testing/SKILL.md
- .codex/skills/devops/SKILL.md

Startup behavior (required):
1. Run `/scan` first to create/update `.ai/project-context.md`.
2. If `project-context.md` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the skill matching your domain (backend, frontend, data, testing, devops).
4. Each skill specifies exactly which section of `project-context.md` to read — load only that section.
5. If critical info is missing, mark `NEEDS CLARIFICATION` and continue with safe defaults.

Recommended execution order:
1. `/scan`       → populate .ai/project-context.md
2. `/spec`       → define feature requirements — creates specs/features/<slug>/ and sets .ai/current
3. `/plan`       → architecture + phased implementation plan (reads .ai/current automatically)
4. `/tasks`      → execution task list with dependencies
5. `/implement`  → execute tasks domain-by-domain
6. `/review`     → validate implementation against spec acceptance criteria
7. `/skill`      → create or edit a project-specific skill

Navigation:
- `/status`      → pipeline snapshot — stage, task counts, next step
- `/switch`      → change active spec without re-running /spec
- `/fix`         → minimal bug fix; add --trace for specs/bugs/<slug>/ traceability

Multi-agent workflow:
- Spec phase (/spec + /plan) → best handled by an analysis-focused agent (Gemini, Claude)
- Implementation phase (/implement) → Codex excels at focused code generation per domain task
- Review phase (/review) → Gemini for gap analysis, Codex for test coverage check
- Shared artifact: specs/<type>/<slug>/ — any agent picks up via .ai/current

Bootstrap command:
`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy`
<!-- .AIAgents Autoload End -->
