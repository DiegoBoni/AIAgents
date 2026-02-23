```
    _    ___    _                    _
   / \  |_ _|  / \   __ _  ___ _ __ | |_ ___
  / _ \  | |  / _ \ / _` |/ _ \ '_ \| __/ __|
 / ___ \ | | / ___ \ (_| |  __/ | | | |_\__ \
/_/   \_\___/_/   \_\__, |\___|_| |_|\__|___/
                    |___/
```

A reusable AI agent framework designed to be bootstrapped into any software project.
Provides structured commands and domain-scoped skills for Claude, Codex, and Gemini — keeping token usage minimal by loading only the context relevant to each task.

---

## The problem this solves

Most AI agent setups load the entire project context on every call. As a project grows, this becomes expensive and noisy. This kit solves that with **domain skills**: each skill loads only the section of the project context it needs.

```
Without this kit:        With this kit:
─────────────────────    ──────────────────────────────
Every task loads:        Backend task loads:
  - Full stack info        - [context.backend] only
  - Frontend config        ~300 words, not 3000
  - DB schemas
  - CI/CD pipelines
  - All standards
  (~3000 words)
```

---

## How it works

### 1. One context file, five domain sections

After running `/context`, the file `.AIAgents/project-context.md` contains both a global summary and five independently loadable domain sections:

```
project-context.md
├── Metadata / Stack / Architecture (global)
├── [context.backend]    ← loaded by backend skill only
├── [context.frontend]   ← loaded by frontend skill only
├── [context.data]       ← loaded by data skill only
├── [context.testing]    ← loaded by testing skill only
└── [context.devops]     ← loaded by devops skill only
```

### 2. Domain skills — available for all 3 agents

Each skill tells the agent exactly what to load and what to ignore.
Skills are tuned per agent: Claude for broad implementation, Codex for focused code generation, Gemini for analysis and design.

| Skill | Domain | Claude | Codex | Gemini |
|---|---|---|---|---|
| `backend` | API, services, auth | implement | implement | analyze / review |
| `frontend` | UI, components, state | implement | implement | analyze / review |
| `data` | DB, migrations, models | implement | implement | analyze / review |
| `testing` | Tests, coverage, CI | implement | implement | strategy / gaps |
| `devops` | CI/CD, infra, secrets | implement | implement | analyze / review |

### 3. Commands (workflow)

Commands handle the planning pipeline. They run once per feature and produce persistent artifacts:

| Command | Invoke as | Input | Output |
|---|---|---|---|
| `context.md` | `/context` | Repo scan | `project-context.md` |
| `spec.md` | `/spec` | Feature description | `specs/<feature>/spec.md` |
| `plan.md` | `/plan` | `spec.md` | `specs/<feature>/plan.md` |
| `tasks.md` | `/tasks` | `plan.md` | `specs/<feature>/tasks.md` |

---

## Recommended workflow

```
New project setup:
  1. bootstrap   →  install commands + skills into target repo
  2. /context    →  scan repo and populate project-context.md

Per feature:
  3. /spec <feature description>      →  spec.md
  4. /plan specs/<feature>/spec.md    →  plan.md
  5. /tasks specs/<feature>/plan.md   →  tasks.md

Per implementation task:
  6. Load the matching domain skill (backend / frontend / data / testing / devops)
  7. Agent reads only [context.<domain>] — not the full file
  8. Implement, verify, ship
```

---

## Agent roles

| Agent | Strength | Use for |
|---|---|---|
| **Claude** | Broad reasoning + implementation | Features, refactors, complex multi-file changes |
| **Codex** | Focused code generation | Targeted implementation, tests, migrations |
| **Gemini** | Analysis + requirements | Design reviews, risk analysis, spec clarification |

---

## Supported agents

| Agent | Commands path | Skills path |
|---|---|---|
| Claude | `.AIAgents/.claude/commands/` | `.AIAgents/.claude/skills/` |
| Codex | `.AIAgents/.codex/commands/` | `.AIAgents/.codex/skills/` |
| Gemini | `.AIAgents/.gemini/commands/` | `.AIAgents/.gemini/skills/` |

Source templates live in `Claude/`, `Codex/`, `Gemini/` and are copied by bootstrap.

---

## Getting started

### Bootstrap into a new project

```bash
# From this repo
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/your/project --agent all --mode copy
```

This will:
- Copy commands into `.AIAgents/.<agent>/commands/`
- Copy domain skills into `.AIAgents/.<agent>/skills/`
- Create `.AIAgents/project-context.md` from template
- Inject startup instructions into `CLAUDE.md`, `AGENTS.md`, and `GEMINI.md`

Options:

```
--repo PATH     Target project path (default: current directory)
--agent AGENT   claude | codex | gemini | all (default: all)
--mode MODE     copy | link (default: copy)
```

### Bootstrap into the current directory

```bash
./.AIAgents/scripts/bootstrap-commands.sh
```

### First session in any project

```
1. /context              # Scan repo and populate project-context.md
2. /spec <feature>       # Define what you're building
3. /plan specs/<f>/spec.md
4. /tasks specs/<f>/plan.md
```

---

## Repository structure

```
.AIAgents/
├── README.md
├── COMMANDS.md                    # Command reference
├── ROUTING.md                     # Agent-to-folder mapping
├── project-context.md             # Generated per project (gitignored or committed)
│
├── _shared/
│   └── templates/
│       ├── project-context-template.md   # Template with domain sections
│       ├── command-template.md
│       ├── skill-template.md
│       └── spec-template.md
│
├── Claude/                        # Source files for Claude
│   ├── commands/
│   │   ├── context.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   └── tasks.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       ├── devops/SKILL.md
│       └── architecture-review/SKILL.md
│
├── Codex/                         # Source files for Codex
│   ├── commands/
│   │   ├── context.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   └── tasks.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       ├── devops/SKILL.md
│       └── coding-standard/SKILL.md
│
├── Gemini/                        # Source files for Gemini
│   ├── commands/
│   │   ├── context.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   └── tasks.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       ├── devops/SKILL.md
│       └── requirements-breakdown/SKILL.md
│
├── .claude/commands/              # Native Claude commands (installed by bootstrap)
├── .codex/commands/               # Native Codex commands (installed by bootstrap)
├── .gemini/commands/              # Native Gemini commands (installed by bootstrap)
│
└── scripts/
    └── bootstrap-commands.sh      # Install script
```

---

## Extending the kit

### Add a new skill

1. Create a folder in each agent source dir: `Claude/skills/<name>/`, `Codex/skills/<name>/`, `Gemini/skills/<name>/`
2. Add `SKILL.md` using the template at `_shared/templates/skill-template.md`
3. Define which section of `project-context.md` the skill reads
4. Re-run bootstrap to deploy to target projects

### Add a new domain section to project-context

1. Add `## [context.<domain>]` to `_shared/templates/project-context-template.md`
2. Update `context.md` (in each agent's commands folder) to extract evidence for the new domain
3. Create matching skills in each agent's skills folder

### Add a new command

1. Create `Claude/commands/<name>.md` using `_shared/templates/command-template.md`
2. Mirror in `Codex/commands/` and `Gemini/commands/` as needed
3. Re-run bootstrap to deploy to target projects

---

## Design principles

- **Minimal context per call** — skills load only what they need, not the full project
- **Evidence-based context** — `/context` extracts facts from the repo, not assumptions
- **Portable** — the entire kit is plain Markdown, works with any agent that reads files
- **Composable** — commands and skills are independent; use only what fits your workflow
- **Transparent** — every assumption is marked, every open question is surfaced
