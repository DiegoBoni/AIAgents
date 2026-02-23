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

## Command set

| Command | Invoke as | Input | Output | When |
|---|---|---|---|---|
| `context.md` | `/context` | Repo scan (optional domain focus) | `.ai/project-context.md` | Once per project / on stack change |
| `spec.md` | `/spec` | Feature description | `specs/<feature>/spec.md` | Once per feature |
| `plan.md` | `/plan` | `specs/<feature>/spec.md` | `specs/<feature>/plan.md` | Once per feature |
| `tasks.md` | `/tasks` | `specs/<feature>/plan.md` | `specs/<feature>/tasks.md` | Once per feature |
| `fix.md` | `/fix` | Bug description + file path(s) | Fixed code + root cause | Per bug, skips spec/plan/tasks |

## Domain skills

Skills load only the relevant section of `project-context.md` — not the full file.

| Skill | Domain | Agent | Reads |
|---|---|---|---|
| `backend/SKILL.md` | API, services, auth | Claude / Codex / Gemini | `[context.backend]` |
| `frontend/SKILL.md` | UI, components, state | Claude / Codex / Gemini | `[context.frontend]` |
| `data/SKILL.md` | DB, migrations, models | Claude / Codex / Gemini | `[context.data]` |
| `testing/SKILL.md` | Tests, coverage, CI | Claude / Codex / Gemini | `[context.testing]` |
| `devops/SKILL.md` | CI/CD, infra, secrets | Claude / Codex / Gemini | `[context.devops]` |

## Bootstrap

Install commands and skills into any repo:

```bash
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/repo --agent all --mode copy
```

Options:

- `--agent`: `codex`, `gemini`, `claude`, `all`
- `--mode`: `copy` or `link`

Bootstrap also:

- copies domain skills into `.AIAgents/.<agent>/skills/`
- injects startup guidance into `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md`
- enforces `/context` as first command
- creates `.AIAgents/project-context.md` if missing

## Integration hint

Map each agent runtime to its own folder:

- Codex: `.AIAgents/.codex/commands/*.md` + `.AIAgents/.codex/skills/*/SKILL.md`
- Gemini: `.AIAgents/.gemini/commands/*.md` + `.AIAgents/.gemini/skills/*/SKILL.md`
- Claude: `.AIAgents/.claude/commands/*.md` + `.AIAgents/.claude/skills/*/SKILL.md`
