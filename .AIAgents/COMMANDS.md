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

### Pipeline commands

| Command | Invoke as | Input | Output | When |
|---|---|---|---|---|
| `scan.md` | `/scan` | Repo scan (optional domain focus) | `.ai/project-context.md` | Once per project / on stack change |
| `spec.md` | `/spec` | Feature description | `specs/features/<slug>/spec.md` | Once per feature |
| `plan.md` | `/plan` | auto from `.ai/current` | `specs/features/<slug>/plan.md` | Once per feature |
| `tasks.md` | `/tasks` | auto from `.ai/current` | `specs/features/<slug>/tasks.md` | Once per feature |
| `implement.md` | `/implement` | auto from `.ai/current` | Code changes + progress report | Per feature, after /tasks |
| `review.md` | `/review` | auto from `.ai/current` | `specs/<type>/<slug>/review.md` | After /implement |
| `fix.md` | `/fix` | Bug description + file path(s) | Fixed code + root cause | Per bug; add `--trace` for spec |
| `skill.md` | `/skill` | Skill name + domain | `.claude/skills/<name>/SKILL.md` | When adding or updating a skill |

### Navigation & ops commands

| Command | Invoke as | Input | Output | When |
|---|---|---|---|---|
| `status.md` | `/status` | none | Inline pipeline snapshot | Anytime — no files written |
| `switch.md` | `/switch` | Spec slug (optional) | Updates `.ai/current` | When changing active spec |
| `harness.md` | `/harness` | `--minimal` or `--full` | `.claude/settings.json` + `.ai/log/` | Once per project setup (Claude only) |

### Active spec pointer

Most commands read `.ai/current` automatically — no path argument needed.

```
.ai/current          ← one line: e.g. specs/features/checkout-flow
specs/
├── features/
│   └── checkout-flow/
│       ├── spec.md
│       ├── plan.md
│       ├── tasks.md
│       └── review.md
└── bugs/
    └── payment-fix/
        ├── spec.md       (created by /fix --trace)
        └── review.md
```

To switch: `/switch user-auth` or `/switch` to list all available specs.

## Multi-agent workflow

Each command has a recommended `agent_role`. Different agents can own different phases:

| Phase | Recommended agent | Command |
|---|---|---|
| Context scan | Any | `/scan` |
| Spec writing | Gemini or Claude | `/spec` |
| Architecture planning | Claude | `/plan` |
| Task breakdown | Claude or Codex | `/tasks` |
| Implementation | Claude or Codex | `/implement` |
| Implementation review | Gemini | `/implement` (Gemini = readiness check) |
| Code review | Gemini or Claude | `/review` |
| Harness setup | Claude only | `/harness` |
| Skill authoring | Claude | `/skill` |
| Navigation | Any | `/status`, `/switch` |

Agents hand off via shared files in `specs/<type>/<slug>/` — the `## Handoff` block in each
`spec.md` tells the next agent who should pick up and at what confidence level.

## Harness integration (Claude Code)

`/harness` wires the Claude Code harness into the project:

```
.claude/settings.json    ← hooks + domain-scoped permissions
.ai/log/session.log      ← audit trail of every file edit
.ai/scripts/
└── on-session-end.sh    ← runs after every Claude Code session
```

Hooks fire automatically — no manual steps after `/harness` is run once.

## Domain skills

Skills load only the relevant section of `project-context.md` — not the full file.

| Skill | Domain | Agent | Reads |
|---|---|---|---|
| `backend/SKILL.md` | API, services, auth | Claude / Codex / Gemini | `[context.backend]` |
| `frontend/SKILL.md` | UI, components, state | Claude / Codex / Gemini | `[context.frontend]` |
| `data/SKILL.md` | DB, migrations, models | Claude / Codex / Gemini | `[context.data]` |
| `testing/SKILL.md` | Tests, coverage, CI | Claude / Codex / Gemini | `[context.testing]` |
| `devops/SKILL.md` | CI/CD, infra, secrets | Claude / Codex / Gemini | `[context.devops]` |

Custom skills can be created with `/skill` — any name, any domain.

## Bootstrap

Install commands and skills into any repo:

```bash
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/repo --agent all --mode copy
```

Options:

- `--agent`: `codex`, `gemini`, `claude`, `all`
- `--mode`: `copy` or `link`

Bootstrap also:

- copies domain skills into `.<agent>/skills/`
- injects startup guidance into `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md`
- creates `.ai/project-context.md`, `specs/features/`, and `specs/bugs/` if missing

## Integration hint

Map each agent runtime to its own folder:

- Codex: `.codex/commands/*.md` + `.codex/skills/*/SKILL.md`
- Gemini: `.gemini/commands/*.md` + `.gemini/skills/*/SKILL.md`
- Claude: `.claude/commands/*.md` + `.claude/skills/*/SKILL.md`
