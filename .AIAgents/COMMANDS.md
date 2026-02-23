# Commands Module

This module provides reusable command specs by agent.

## Layout

- `.AIAgents/Codex/commands/`
- `.AIAgents/Gemini/commands/`
- `.AIAgents/Claude/commands/`
- `.AIAgents/.codex/commands/`
- `.AIAgents/.gemini/commands/`
- `.AIAgents/.claude/commands/`
- `.AIAgents/_shared/templates/command-template.md`
- `.AIAgents/_shared/templates/project-context-template.md`
- `.AIAgents/scripts/bootstrap-commands.sh`

## Baseline command set

- `cmd.specify.md`: request -> spec
- `cmd.plan.md`: spec -> plan
- `cmd.tasks.md`: plan -> tasks
- `cmd.context.md`: repo scan -> project context profile

## Bootstrap

Install native command folders in any repo:

```bash
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/repo --agent all --mode copy
```

Options:

- `--agent`: `codex`, `gemini`, `claude`, `all`
- `--mode`: `copy` or `link`

Bootstrap also:

- injects startup guidance into `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md`
- enforces `cmd.context` as first command
- creates `.AIAgents/project-context.md` if missing

## Integration hint

Map each agent runtime to its command folder.

- Codex: `.AIAgents/.codex/commands/*.md`
- Gemini: `.AIAgents/.gemini/commands/*.md`
- Claude: `.AIAgents/.claude/commands/*.md`
