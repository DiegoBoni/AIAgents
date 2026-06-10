# Claude Instructions

Load command files from `.claude/commands/*.md`.

<!-- .AIAgents Autoload Start -->
Slash commands (legacy, kept for compatibility):
Load command files from .claude/commands/*.md

Workflow skills — invoke by name to execute a pipeline step:
- scan         → populate .ai/project-context.md
- spec         → define feature requirements (creates .ai/current)
- plan         → architecture + phased implementation plan
- tasks        → execution task list with dependencies
- implement    → execute tasks domain-by-domain with progress tracking
- spec-review  → validate implementation against spec acceptance criteria
- fix          → minimal bug fix (add --trace for bug spec traceability)
- status       → pipeline snapshot — stage, task counts, next step
- switch       → change active spec without re-running spec
- mkskill      → create or update a project-specific skill
- harness      → configure Claude Code hooks and permissions

Domain skills — load only the skill matching your current task:
- .claude/skills/backend/SKILL.md
- .claude/skills/frontend/SKILL.md
- .claude/skills/data/SKILL.md
- .claude/skills/testing/SKILL.md
- .claude/skills/devops/SKILL.md

Startup behavior (required):
1. Invoke the `scan` skill first to create/update `.ai/project-context.md`.
2. If `project-context.md` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the domain skill matching your work (backend, frontend, data, testing, devops).
4. Each domain skill specifies exactly which section of `project-context.md` to read — load only that section.
5. If critical info is missing, mark `NEEDS CLARIFICATION` and continue with safe defaults.

Multi-agent workflow:
- Spec phase (spec + plan) → best handled by an analysis-focused agent (Gemini, Claude)
- Implementation phase (implement) → best handled by a code-generation agent (Claude, Codex)
- Shared artifact: specs/<feature>/ — any agent can hand off to another via these files

Bootstrap command:
`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy`
<!-- .AIAgents Autoload End -->
