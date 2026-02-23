# AI Module (.AIAgents)

Reusable Markdown module to import into any software project.

## Structure

- `.AIAgents/_shared/templates/`: base templates for skills, commands, and project specs.
- `.AIAgents/Codex/`: commands, skills, and specs tuned for Codex.
- `.AIAgents/Gemini/`: commands, skills, and specs tuned for Gemini.
- `.AIAgents/Claude/`: commands, skills, and specs tuned for Claude.
- `.AIAgents/.codex/`, `.AIAgents/.gemini/`, `.AIAgents/.claude/`: native command folders per agent runtime.
- `.AIAgents/COMMANDS.md`: command module overview.
- `.AIAgents/ROUTING.md`: how to map each agent to its own folders.

## Important

Folder names by themselves do not activate skills or commands. Each agent must be configured to discover and load the corresponding files.

## Suggested use

1. Copy `.AIAgents/` into a target project.
2. Run `./.AIAgents/scripts/bootstrap-commands.sh --repo <project-path> --agent all --mode copy`.
3. Start every new session with `cmd.context`.
4. Keep `.AIAgents/project-context.md` updated whenever stack, integrations, or standards change.
