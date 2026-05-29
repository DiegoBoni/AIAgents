```
    _    ___    _                    _
   / \  |_ _|  / \   __ _  ___ _ __ | |_ ___
  / _ \  | |  / _ \ / _` |/ _ \ '_ \| __/ __|
 / ___ \ | | / ___ \ (_| |  __/ | | | |_\__ \
/_/   \_\___/_/   \_\__, |\___|_| |_|\__|___/
                    |___/
```

A reusable AI agent framework designed to be bootstrapped into any software project.
Provides a structured spec-driven pipeline with multi-agent support, harness engineering,
and domain-scoped skills for Claude, Codex, and Gemini — keeping token usage minimal by
loading only the context relevant to each task.

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

Most AI agent setups load the entire project context on every call. As a project grows,
this becomes expensive and noisy. This kit solves that with **domain skills**: each skill
loads only the section of the project context it needs.

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

After running `/scan`, the file `.ai/project-context.md` contains a global summary and
five independently loadable domain sections:

```
.ai/project-context.md
├── Metadata / Stack / Architecture   (global — loaded by /scan and /spec)
├── [context.backend]    ← loaded by backend skill only
├── [context.frontend]   ← loaded by frontend skill only
├── [context.data]       ← loaded by data skill only
├── [context.testing]    ← loaded by testing skill only
└── [context.devops]     ← loaded by devops skill only
```

### 2. Active spec pointer — .ai/current

Every spec-related command reads `.ai/current` automatically.
No need to pass file paths between commands.

```
.ai/
├── project-context.md     ← populated by /scan
├── current                ← "specs/features/checkout-flow"  (set by /spec)
├── log/
│   └── session.log        ← audit trail (populated by /harness hooks)
└── scripts/
    └── on-session-end.sh  ← runs after every Claude Code session

specs/
├── features/
│   ├── checkout-flow/
│   │   ├── spec.md        ← created by /spec
│   │   ├── plan.md        ← created by /plan
│   │   ├── tasks.md       ← created by /tasks
│   │   └── review.md      ← created by /review
│   └── user-auth/
│       └── spec.md
└── bugs/
    └── payment-timeout/
        └── spec.md        ← created by /fix --trace
```

Use `/switch` to change the active spec. Use `/status` to see where you are in the pipeline.

### 3. Domain skills — available for all 3 agents

Each skill tells the agent exactly what to load and what to ignore.
Skills are tuned per agent: Claude for broad implementation, Codex for focused code
generation, Gemini for analysis and design.

| Skill | Domain | Claude | Codex | Gemini |
|---|---|---|---|---|
| `backend` | API, services, auth | implement | implement | analyze / review |
| `frontend` | UI, components, state | implement | implement | analyze / review |
| `data` | DB, migrations, models | implement | implement | analyze / review |
| `testing` | Tests, coverage, CI | implement | implement | strategy / gaps |
| `devops` | CI/CD, infra, secrets | implement | implement | analyze / review |

Create project-specific skills at any time with `/skill <name> <domain>`.

### 4. Commands — the full pipeline

#### Pipeline commands

| Command | Invoke as | Input | Output |
|---|---|---|---|
| `scan.md` | `/scan` | Repo (optional domain) | `.ai/project-context.md` |
| `spec.md` | `/spec` | Feature description | `specs/features/<slug>/spec.md` + sets `.ai/current` |
| `plan.md` | `/plan` | auto from `.ai/current` | `specs/features/<slug>/plan.md` |
| `tasks.md` | `/tasks` | auto from `.ai/current` | `specs/features/<slug>/tasks.md` |
| `implement.md` | `/implement` | auto from `.ai/current` | Code changes + progress report |
| `review.md` | `/review` | auto from `.ai/current` | `specs/<type>/<slug>/review.md` |
| `fix.md` | `/fix` | Bug description + file(s) | Fixed code + root cause |
| `skill.md` | `/skill` | Name + domain | `.claude/skills/<name>/SKILL.md` |

#### Navigation & ops commands

| Command | Invoke as | Input | Output |
|---|---|---|---|
| `status.md` | `/status` | none | Inline pipeline snapshot (read-only) |
| `switch.md` | `/switch` | Spec slug (optional) | Updates `.ai/current` |
| `harness.md` | `/harness` | `--minimal` or `--full` | `.claude/settings.json` + `.ai/log/` |

### 5. Harness integration (Claude Code)

`/harness` wires the Claude Code harness into the project:

```
.claude/settings.json    ← PostToolUse hooks log every file edit
                            Stop hook runs on-session-end.sh
                            Domain-scoped permissions (--full)
.ai/log/session.log      ← audit trail: timestamp | EDIT | filepath
.ai/scripts/
└── on-session-end.sh    ← customize: run tests, lint, auto-commit
```

Run `/harness` once per project. After that, hooks fire automatically every session —
no manual steps needed.

---

## Recommended workflow

### New project setup

```
1. bootstrap / install  →  copy commands + skills into project
2. /scan                →  populate .ai/project-context.md
3. /harness             →  set up hooks, audit log, domain permissions (Claude Code)
```

### New feature — single agent

```
4. /spec <description>  →  specs/features/<slug>/  +  .ai/current set
5. /plan                →  reads .ai/current automatically
6. /tasks               →  reads .ai/current automatically
7. /implement           →  executes tasks with TodoWrite + parallel sub-agents
8. /review              →  validates acceptance criteria: ✅ green / ⚠️ amber / ❌ red
```

### New feature — multi-agent

```
4. Gemini:  /spec       →  requirements analysis, creates spec.md + Handoff block
5. Claude:  /plan       →  architecture decisions, reads spec.md via .ai/current
6. Claude:  /tasks      →  dependency graph, parallelizable domain batches
7. Codex:   /implement  →  focused code generation per domain task
8. Gemini:  /review     →  gap analysis between spec intent and implementation
```

All agents share `.ai/project-context.md` and `specs/<type>/<slug>/`.
The `## Handoff` block at the end of every `spec.md` tells the next agent who picks up
and at what confidence level — no context needs to be re-explained.

### Bug fix

```
/fix <description> <file>          →  minimal fix, domain auto-detected
/fix <description> <file> --trace  →  fix + creates specs/bugs/<slug>/ for traceability
```

### Navigation

```
/status   →  stage, task counts, quality gates, recent activity, next step
/switch   →  list all specs + progress, or switch to a named spec instantly
```

---

## Agent roles

| Agent | Strength | Best for | Commands |
|---|---|---|---|
| **Claude** | Broad reasoning, orchestration, harness | Full pipeline, multi-file features, sub-agent spawning | all commands |
| **Codex** | Focused code generation | Domain-scoped implementation, tests, migrations | `/implement` `/fix` `/scan` `/spec` `/review` `/status` `/switch` |
| **Gemini** | Requirements analysis, gap detection | Spec writing, readiness review, code review | `/spec` `/implement` `/review` `/status` `/switch` |

### Multi-agent handoff

```
spec.md always ends with:

  ## Handoff
  - Spec owner: Gemini
  - Plan agent: Claude
  - Implementation agent: Codex
  - Spec confidence: high
  - Blocking questions: none
  - Ready for /plan: yes
```

Any agent can pick up where another left off — just open the project and run the next command.
`.ai/current` tells every command where the active spec lives.

---

## Supported agents

After bootstrap, each agent reads from the **project root**:

| Agent | Commands path | Skills path |
|---|---|---|
| Claude | `.claude/commands/` | `.claude/skills/` |
| Codex | `.codex/commands/` | `.codex/skills/` |
| Gemini | `.gemini/commands/` | `.gemini/skills/` |

Shared files: `.ai/project-context.md`, `.ai/current`, `specs/`.

---

## Getting started

### Option 1 — Install via curl (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh)
```

### Option 2 — Bootstrap manually (if you cloned this repo)

```bash
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/your/project
```

### Options

```
--agent AGENT   claude | codex | gemini | all  (default: all)
--mode  MODE    copy | link                    (default: copy)
--target PATH   target project path            (install.sh only)
--repo  PATH    target project path            (bootstrap-commands.sh only)
```

`copy` — standalone files. `link` — symlinks; updating this repo updates all linked projects.

### What gets installed

```
<your-project>/
├── .claude/
│   ├── commands/    ← scan spec plan tasks implement review fix skill
│   │                  status switch harness
│   └── skills/      ← backend  frontend  data  testing  devops
├── .codex/
│   ├── commands/    ← scan spec plan tasks implement review fix skill
│   │                  status switch
│   └── skills/      ← backend  frontend  data  testing  devops
├── .gemini/
│   ├── commands/    ← scan spec plan tasks implement review fix skill
│   │                  status switch
│   └── skills/      ← backend  frontend  data  testing  devops
├── .ai/
│   └── project-context.md
├── specs/
│   ├── features/
│   └── bugs/
├── CLAUDE.md
├── AGENTS.md
└── GEMINI.md
```

### First session

```
1. /scan              →  scan repo, populate .ai/project-context.md
2. /harness           →  wire hooks + audit log (Claude Code, run once)
3. /spec <feature>    →  creates specs/features/<slug>/ + sets .ai/current
4. /plan              →  no args needed — reads .ai/current
5. /tasks             →  no args needed
6. /implement         →  no args needed — TodoWrite + parallel sub-agents
7. /review            →  validate acceptance criteria, save review.md
```

Check progress at any time: `/status`
Switch to another spec: `/switch`

---

## Repository structure

### Source (this repo)

```
.AIAgents/
├── COMMANDS.md
├── ROUTING.md
├── _shared/
│   └── templates/
│       ├── project-context-template.md
│       ├── command-template.md
│       ├── skill-template.md
│       └── spec-template.md
│
├── Claude/
│   ├── commands/
│   │   ├── scan.md        harness.md
│   │   ├── spec.md        review.md
│   │   ├── plan.md        status.md
│   │   ├── tasks.md       switch.md
│   │   ├── implement.md   skill.md
│   │   └── fix.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       └── devops/SKILL.md
│
├── Codex/
│   ├── commands/
│   │   ├── scan.md        review.md
│   │   ├── spec.md        status.md
│   │   ├── plan.md        switch.md
│   │   ├── tasks.md       skill.md
│   │   ├── implement.md
│   │   └── fix.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       └── devops/SKILL.md
│
├── Gemini/
│   ├── commands/
│   │   ├── scan.md        review.md
│   │   ├── spec.md        status.md
│   │   ├── plan.md        switch.md
│   │   ├── tasks.md       skill.md
│   │   ├── implement.md   (readiness review mode)
│   │   └── fix.md
│   └── skills/
│       ├── backend/SKILL.md
│       ├── frontend/SKILL.md
│       ├── data/SKILL.md
│       ├── testing/SKILL.md
│       └── devops/SKILL.md
│
└── scripts/
    └── bootstrap-commands.sh
```

---

## Extending the kit

### Add a custom skill for your project

```bash
/skill <name> <domain>
```

The command reads your project context and generates a `SKILL.md` specific to your stack —
not a generic template.

### Add a new shared skill (across all projects)

1. Create `Claude/skills/<name>/SKILL.md`, mirror in `Codex/` and `Gemini/`.
2. Re-run bootstrap to deploy.

### Add a new command

1. Create `Claude/commands/<name>.md` from `_shared/templates/command-template.md`.
2. Mirror in `Codex/commands/` and `Gemini/commands/` as needed.
3. Re-run bootstrap to deploy.

---

## Design principles

- **Minimal context per call** — skills load only what they need, not the full project
- **Evidence-based context** — `/scan` extracts facts from the repo, not assumptions
- **Active spec pointer** — `.ai/current` keeps all pipeline commands in sync without passing paths
- **Structured for handoff** — every spec ends with a `## Handoff` block so any agent can resume
- **Harness-native** — `/harness` integrates with Claude Code hooks for automatic auditing
- **Composable** — commands and skills are independent; use only what fits your workflow
- **Portable** — plain Markdown files, works with any agent that reads files
- **Transparent** — every assumption is marked, every open question is surfaced
