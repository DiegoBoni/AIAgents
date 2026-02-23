# AI Module (.AIAgents)

Reusable Markdown module to import into any software project.
Provides commands for the planning workflow and domain-scoped skills to minimize token usage per task.

---

## Structure

```
.AIAgents/
├── project-context.md             # Populated by cmd.context — source of truth
├── COMMANDS.md                    # Command reference
├── ROUTING.md                     # Agent-to-folder mapping
│
├── _shared/templates/             # Base templates
│   ├── project-context-template.md
│   ├── command-template.md
│   ├── skill-template.md
│   └── spec-template.md
│
├── Claude/                        # Claude source files
│   ├── commands/                  # cmd.context, cmd.specify, cmd.plan, cmd.tasks
│   └── skills/                    # backend, frontend, data, testing, devops, architecture-review
│
├── Codex/                         # Codex source files
│   ├── commands/
│   └── skills/
│
├── Gemini/                        # Gemini source files
│   ├── commands/
│   └── skills/
│
├── .claude/commands/              # Native Claude loader (installed by bootstrap)
├── .codex/commands/               # Native Codex loader (installed by bootstrap)
├── .gemini/commands/              # Native Gemini loader (installed by bootstrap)
│
└── scripts/
    └── bootstrap-commands.sh
```

---

## Key concept: domain skills

Each skill loads only one section of `project-context.md`, not the full file.

| Skill | Reads |
|---|---|
| `backend` | `[context.backend]` |
| `frontend` | `[context.frontend]` |
| `data` | `[context.data]` |
| `testing` | `[context.testing]` |
| `devops` | `[context.devops]` |

This keeps token usage low and context noise minimal.

---

## Important

Folder names alone do not activate skills or commands. Each agent must be configured to discover and load the corresponding files. The bootstrap script handles this automatically.

---

## Suggested use

1. Copy `.AIAgents/` into a target project.
2. Run `./.AIAgents/scripts/bootstrap-commands.sh --repo <project-path> --agent all --mode copy`.
3. Start every new session with `cmd.context` to populate `project-context.md`.
4. For each implementation task, load only the domain skill that matches your work.
5. Keep `project-context.md` updated whenever stack, integrations, or standards change.

See the root `README.md` for the full workflow and design reference.
