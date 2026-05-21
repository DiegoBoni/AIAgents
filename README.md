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

## Install

Run this from inside **any project** you want to set up:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh)
```

With options:

```bash
# Only Claude
bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh) --agent claude

# Specific target folder
bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh) --target /path/to/project

# All agents, symlink mode (updates automatically when this repo changes)
bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh) --agent all --mode link
```

After install, open the project in your agent and run `/scan` to get started.

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

After running `/scan`, the file `.AIAgents/project-context.md` contains both a global summary and five independently loadable domain sections:

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

| Command | Invoke as | When to use | Output |
|---|---|---|---|
| `scan.md` | `/scan` | Once per project, on stack change | `.ai/project-context.md` |
| `spec.md` | `/spec` | Once per feature | `specs/<feature>/spec.md` |
| `plan.md` | `/plan` | Once per feature | `specs/<feature>/plan.md` |
| `tasks.md` | `/tasks` | Once per feature | `specs/<feature>/tasks.md` |
| `implement.md` | `/implement` | After /tasks — execute domain-by-domain | Code changes + progress report |
| `fix.md` | `/fix` | Per bug — skips spec/plan/tasks | Fixed code + root cause |
| `skill.md` | `/skill` | Create or update a project skill | `.claude/skills/<name>/SKILL.md` |

`/fix` auto-detects the domain from the file path, loads only that context section, and applies the minimal fix.

`/implement` uses TodoWrite to track task progress and can spawn sub-agents for parallel domain work.

`/skill` reads the current project context to generate a skill tailored to this project's stack.

---

## Recommended workflow

```
New project setup:
  1. bootstrap   →  install commands + skills into target repo
  2. /scan       →  scan repo, populate .ai/project-context.md

New feature (single agent):
  3. /spec <description>   →  spec.md (includes handoff block)
  4. /plan                 →  plan.md
  5. /tasks                →  tasks.md
  6. /implement            →  executes tasks, tracks via TodoWrite

New feature (multi-agent):
  3. Gemini: /spec         →  spec.md (Gemini excels at requirements analysis)
  4. Claude: /plan         →  reads spec.md, produces plan.md
  5. Claude: /tasks        →  produces tasks.md
  6. Codex:  /implement    →  focused code generation per domain task
  All agents share: specs/<feature>/ and .ai/project-context.md

Bug fix:
  /fix <description> <file>   →  detects domain, minimal fix, root cause

Custom skill:
  /skill <name> <domain>      →  creates project-specific skill from current context
```

---

## Agent roles

| Agent | Strength | Use for | Commands |
|---|---|---|---|
| **Claude** | Broad reasoning + implementation | Features, refactors, complex multi-file changes, harness orchestration | `/scan` `/spec` `/plan` `/tasks` `/implement` `/skill` |
| **Codex** | Focused code generation | Targeted implementation, tests, migrations | `/implement` `/fix` |
| **Gemini** | Analysis + requirements | Design reviews, risk analysis, spec clarification | `/spec` `/implement` (readiness review) |

### Multi-agent pattern

Agents share state through files in `specs/<feature>/` and `.ai/project-context.md`.
The `## Handoff` block at the end of every `spec.md` tells the next agent:
- who wrote the spec
- which agent should own planning and implementation
- confidence level and blocking questions

Claude can also orchestrate sub-agents internally via the Agent tool, spinning up
independent domain agents in parallel within a single `/implement` run.

---

## Supported agents

After bootstrap, each agent reads from the **project root** — not inside `.AIAgents/`:

| Agent | Commands path | Skills path |
|---|---|---|
| Claude | `.claude/commands/` | `.claude/skills/` |
| Codex | `.codex/commands/` | `.codex/skills/` |
| Gemini | `.gemini/commands/` | `.gemini/skills/` |

The shared context file lives at `.ai/project-context.md`.
Source templates live in `.AIAgents/Claude/`, `Codex/`, `Gemini/` and are only used by this repo.

---

## Getting started

### Option 1 — Install via curl (recommended)

From inside any project:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh)
```

### Option 2 — Bootstrap manually (if you cloned this repo)

```bash
# From the AIAgents repo root, targeting another project
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/your/project

# Or install into the current directory
./.AIAgents/scripts/bootstrap-commands.sh
```

### Options (both methods)

```
--agent AGENT   claude | codex | gemini | all  (default: all)
--mode  MODE    copy | link                    (default: copy)
--target PATH   target project path            (install.sh only)
--repo  PATH    target project path            (bootstrap-commands.sh only)
```

`copy` — files are copied, standalone.
`link` — files are symlinked; updating this repo updates all linked projects automatically.

### What gets installed

```
<your-project>/
├── .claude/commands/    ← /scan  /spec  /plan  /tasks  /implement  /skill
├── .claude/skills/      ← backend  frontend  data  testing  devops
├── .codex/  ...
├── .gemini/ ...
├── .ai/project-context.md
├── CLAUDE.md
├── AGENTS.md
└── GEMINI.md
```

### First session in any project

```
1. /scan                 → scans repo, populates .ai/project-context.md
2. /spec <feature>       → creates specs/<feature>/spec.md (with handoff block for multi-agent)
3. /plan                 → creates specs/<feature>/plan.md
4. /tasks                → creates specs/<feature>/tasks.md
5. /implement            → executes tasks domain-by-domain with progress tracking
   /skill <name> <domain> → create or update a project-specific skill
```

---

## Repository structure

### This repo (source)

```
.AIAgents/
├── README.md
├── COMMANDS.md                    # Command reference
├── ROUTING.md                     # Agent-to-folder mapping
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
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── fix.md
│   │   └── skill.md
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
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── fix.md
│   │   └── skill.md
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
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md   (readiness review mode)
│   │   ├── fix.md
│   │   └── skill.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       ├── devops/SKILL.md
│       └── requirements-breakdown/SKILL.md
│
└── scripts/
    └── bootstrap-commands.sh      # Install script
```

### Target project (after bootstrap)

```
<your-project>/
├── .claude/
│   ├── commands/                  # context.md, spec.md, plan.md, tasks.md
│   └── skills/                    # backend, frontend, data, testing, devops
├── .codex/
│   ├── commands/
│   └── skills/
├── .gemini/
│   ├── commands/
│   └── skills/
├── .ai/
│   └── project-context.md         # populated by /scan
├── CLAUDE.md                      # Claude startup instructions
├── AGENTS.md                      # Codex startup instructions
└── GEMINI.md                      # Gemini startup instructions
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
- **Evidence-based context** — `/scan` extracts facts from the repo, not assumptions
- **Portable** — the entire kit is plain Markdown, works with any agent that reads files
- **Composable** — commands and skills are independent; use only what fits your workflow
- **Transparent** — every assumption is marked, every open question is surfaced
