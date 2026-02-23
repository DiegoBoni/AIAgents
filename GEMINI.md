# Gemini Instructions

Load command files from `.AIAgents/.gemini/commands/*.md`.

<!-- .AIAgents Autoload Start -->
Load command files from .AIAgents/.gemini/commands/*.md

Startup behavior (required):
1. Run `cmd.context` first to create/update `.AIAgents/project-context.md`.
2. If `project-context.md` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Use `project-context.md` as source of truth before planning or coding.
4. If critical info is missing, mark `NEEDS CLARIFICATION` and continue with safe defaults.

Recommended execution order:
1. `cmd.context`
2. `cmd.specify`
3. `cmd.plan`
4. `cmd.tasks`

Bootstrap command:
`./.AIAgents/scripts/bootstrap-commands.sh --repo /Users/boni/Documents/New project --agent all --mode copy`
<!-- .AIAgents Autoload End -->
