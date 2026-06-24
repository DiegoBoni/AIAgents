# Agent Routing Guide

Folder names alone are not enough. Each agent needs explicit configuration to discover where skills and commands live.

## Structure in the target project (after bootstrap)

```
<project-root>/
├── .claude/
│   ├── commands/          ← loaded natively by Claude Code
│   └── skills/
├── .codex/
│   ├── commands/          ← loaded natively by Codex
│   └── skills/
├── .gemini/
│   ├── commands/          ← loaded natively by Gemini
│   └── skills/
├── .copilot/
│   ├── commands/          ← prompt templates (paste into Copilot Chat)
│   └── skills/
├── .github/
│   └── copilot-instructions.md  ← Copilot startup instructions
├── .ai/
│   └── project-context.md ← shared context file
├── CLAUDE.md              ← Claude startup instructions
├── AGENTS.md              ← Codex startup instructions
└── GEMINI.md              ← Gemini startup instructions
```

The `.AIAgents/` folder stays **only in this source repo** — it is not copied to target projects.

## Native agent paths (target project)

| Agent | Commands | Skills | Startup file |
|---|---|---|---|
| Claude | `.claude/commands/*.md` | `.claude/skills/*/SKILL.md` | `CLAUDE.md` |
| Codex | `.codex/commands/*.md` | `.codex/skills/*/SKILL.md` | `AGENTS.md` |
| Gemini | `.gemini/commands/*.md` | `.gemini/skills/*/SKILL.md` | `GEMINI.md` |
| Copilot | `.copilot/commands/*.md` ¹ | `.github/skills/*/SKILL.md` ² | `.github/copilot-instructions.md` |

¹ Copilot has no native slash commands — these are prompt templates to paste in Copilot Chat.
² Skills in `.github/skills/` are auto-discovered by Copilot Agent Mode (VS Code). In regular chat, paste manually.

## Source paths (this repo only)

| Agent | Commands (source) | Skills (source) |
|---|---|---|
| Claude | `.AIAgents/Claude/commands/*.md` | `.AIAgents/Claude/skills/*/SKILL.md` |
| Codex | `.AIAgents/Codex/commands/*.md` | `.AIAgents/Codex/skills/*/SKILL.md` |
| Gemini | `.AIAgents/Gemini/commands/*.md` | `.AIAgents/Gemini/skills/*/SKILL.md` |
| Copilot | `.AIAgents/Copilot/commands/*.md` | `.AIAgents/Copilot/skills/*/SKILL.md` → installs to `.github/skills/` |

## How to make it work

1. Run bootstrap — it copies source files into the correct native folders at the project root.
2. Each agent runtime scans only its own folder (`.claude/`, `.codex/`, `.gemini/`).
3. Skills live in `skills/<name>/SKILL.md` within the agent folder.
4. Commands are single `.md` files invoked by name (e.g. `scan.md` → `/scan`).

## Agent roles

| Agent | Strength | Best for |
|---|---|---|
| **Claude** | Broad reasoning + implementation | Features, refactors, complex tasks |
| **Codex** | Focused code generation | Implementation, tests, migrations |
| **Gemini** | Analysis + requirements | Design reviews, risk analysis, spec clarification |
| **Copilot** | IDE-integrated, model-agnostic | In-editor tasks, inline suggestions, quick fixes |

## Notes

- `project-context.md` lives in `.ai/` — neutral folder shared by all agents.
- Skills are loaded manually per task — agents do not auto-load all skills.
- Re-run bootstrap after adding new skills to propagate them to target projects.
