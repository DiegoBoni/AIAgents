# AI Module (.AIAgents)

Reusable Markdown module to import into any software project.
Provides workflow skills for the planning pipeline and domain-scoped skills to minimize token usage per task.
Supports four AI agents: Claude, Codex, Gemini, and GitHub Copilot.

---

## Structure

```
.AIAgents/
├── COMMANDS.md                    # Command reference (legacy)
├── ROUTING.md                     # Agent-to-folder mapping
│
├── _shared/templates/             # Base templates
│   ├── project-context-template.md
│   ├── command-template.md
│   ├── skill-template.md
│   └── spec-template.md
│
├── Claude/                        # Claude source files
│   ├── commands/                  # Slash commands (legacy, kept for compatibility)
│   └── skills/
│       ├── scan/                  # Workflow: populate project-context.md
│       ├── spec/                  # Workflow: write feature/bug spec
│       ├── plan/                  # Workflow: phased implementation plan
│       ├── tasks/                 # Workflow: atomic task list
│       ├── implement/             # Workflow: execute tasks domain-by-domain
│       ├── spec-review/           # Workflow: validate implementation vs spec
│       ├── fix/                   # Workflow: minimal bug fix
│       ├── status/                # Workflow: pipeline snapshot
│       ├── switch/                # Workflow: change active spec
│       ├── mkskill/               # Workflow: create/update a project skill
│       ├── harness/               # Workflow: configure Claude Code hooks
│       ├── backend/               # Domain: backend tasks
│       ├── frontend/              # Domain: frontend tasks
│       ├── data/                  # Domain: data layer tasks
│       ├── testing/               # Domain: test writing and coverage
│       ├── devops/                # Domain: CI/CD and infrastructure
│       └── architecture-review/   # Domain: architecture decisions
│
├── Codex/                         # Codex source files
│   ├── commands/                  # Slash commands (primary mechanism for Codex)
│   └── skills/                    # Domain skills
│
├── Gemini/                        # Gemini source files
│   ├── commands/                  # Slash commands (primary mechanism for Gemini)
│   └── skills/                    # Domain skills
│
├── Copilot/                       # GitHub Copilot source files
│   ├── commands/                  # Prompt templates (paste into Copilot Chat)
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── fix.md
│   │   ├── status.md
│   │   ├── switch.md
│   │   └── mcp-create.md          # Interactive MCP server configurator
│   └── skills/                    # Domain skills (model-agnostic, YAML frontmatter)
│
└── scripts/
    └── bootstrap-commands.sh
```

---

## Key concepts

### Workflow skills (Claude Code)

Claude Code discovers skills from `.claude/skills/*/SKILL.md` and exposes them via the Skill tool.
Each workflow skill is a self-contained action prompt for one step of the planning pipeline:

| Skill          | Purpose                                              |
|----------------|------------------------------------------------------|
| `scan`         | Populate `.ai/project-context.md` from repo evidence |
| `spec`         | Write a feature or bug spec, set `.ai/current`       |
| `plan`         | Phased implementation plan from spec                 |
| `tasks`        | Atomic task list with domain assignments             |
| `implement`    | Execute tasks domain-by-domain with sub-agents       |
| `spec-review`  | Validate implementation against spec criteria        |
| `fix`          | Minimal bug fix; `--trace` for bug spec traceability |
| `status`       | Read-only pipeline snapshot                          |
| `switch`       | Change active spec without re-running spec           |
| `mkskill`      | Create or update a project-specific skill            |
| `harness`      | Configure Claude Code hooks and permissions          |

### Domain skills (all agents)

Each domain skill loads only one section of `project-context.md`, not the full file.
This keeps token usage low and context noise minimal.
All domain skills include YAML frontmatter (`name` + `description`) for native auto-discovery.

| Skill      | Reads                  |
|------------|------------------------|
| `backend`  | `[context.backend]`    |
| `frontend` | `[context.frontend]`   |
| `data`     | `[context.data]`       |
| `testing`  | `[context.testing]`    |
| `devops`   | `[context.devops]`     |

### Agent mechanisms

| Agent   | Workflow commands      | Domain skills         | Config file                       |
|---------|------------------------|-----------------------|-----------------------------------|
| Claude  | `.claude/skills/`      | `.claude/skills/`     | `CLAUDE.md`                       |
| Codex   | `.codex/commands/`     | `.codex/skills/`      | `AGENTS.md`                       |
| Gemini  | `.gemini/commands/`    | `.gemini/skills/`     | `GEMINI.md`                       |
| Copilot | `.copilot/commands/` ¹ | `.github/skills/` ²   | `.github/copilot-instructions.md` |

¹ Copilot has no native slash commands — these are prompt templates to paste in Copilot Chat.  
² Skills in `.github/skills/` are auto-discovered by Copilot Agent Mode (VS Code). In regular chat, paste the skill content manually.

Claude Code uses the native skill system (`skills/*/SKILL.md`) — these appear in the
system context and are invoked via the Skill tool. Codex and Gemini use slash commands
loaded from their respective `commands/` folders.

### GitHub Copilot — features

**Skills (auto-discovery):** Domain skills installed in `.github/skills/` are automatically
activated by Copilot Agent Mode when your prompt is relevant to a domain. No manual loading needed.

**Commands (prompt templates):** Workflow commands are Markdown files you open and paste into
Copilot Chat to execute a pipeline step. They are model-agnostic — they work with GPT-4o,
Claude Sonnet, Gemini, or any other model powering Copilot.

**MCP servers (`mcp-create`):** Use `.copilot/commands/mcp-create.md` to add an MCP server
to your project interactively. Copilot will ask whether the server is remote (HTTP) or local
(npx/command), collect the necessary details, and generate the correct entry in `.vscode/mcp.json`
without hardcoding secrets (uses `${env:VAR}` references).

---

## Suggested use

1. Copy `.AIAgents/` into a target project.
2. Run `./.AIAgents/scripts/bootstrap-commands.sh --repo <project-path> --agent all --mode copy`.
3. Start every new session with the `scan` skill to populate `project-context.md`.
4. Use workflow skills in order: `scan` → `spec` → `plan` → `tasks` → `implement` → `spec-review`.
5. For each implementation task, load only the domain skill that matches your work.
6. Keep `project-context.md` updated whenever stack, integrations, or standards change.

### Bootstrap options

```bash
# All agents
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/project --agent all --mode copy

# Single agent
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/project --agent copilot

# Symlink mode (changes in .AIAgents propagate automatically)
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/project --agent all --mode link
```
