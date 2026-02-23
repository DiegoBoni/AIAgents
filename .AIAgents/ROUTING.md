# Agent Routing Guide

Folder names alone are not enough. Each agent needs explicit configuration to discover where skills and commands live.

## Suggested mapping

| Agent | Commands | Skills |
|---|---|---|
| Claude | `.AIAgents/.claude/commands/*.md` | `.AIAgents/.claude/skills/*/SKILL.md` |
| Codex | `.AIAgents/.codex/commands/*.md` | `.AIAgents/.codex/skills/*/SKILL.md` |
| Gemini | `.AIAgents/.gemini/commands/*.md` | `.AIAgents/.gemini/skills/*/SKILL.md` |

Source templates (not loaded directly by agents):

| Agent | Commands (source) | Skills (source) |
|---|---|---|
| Claude | `.AIAgents/Claude/commands/*.md` | `.AIAgents/Claude/skills/*/SKILL.md` |
| Codex | `.AIAgents/Codex/commands/*.md` | `.AIAgents/Codex/skills/*/SKILL.md` |
| Gemini | `.AIAgents/Gemini/commands/*.md` | `.AIAgents/Gemini/skills/*/SKILL.md` |

## How to make it work

1. Run bootstrap to copy source files into the native agent folders.
2. Configure each agent runtime to scan only its own native folder (`.AIAgents/.<agent>/`).
3. Each skill lives in its own directory as `SKILL.md`.
4. Each command is a single `.md` file invoked by its filename (e.g. `context.md` → `/context`).

## Agent roles

Each agent has a distinct focus — use the matching skill for the task:

| Agent | Strength | Best for |
|---|---|---|
| **Claude** | Broad reasoning + implementation | Features, refactors, complex tasks |
| **Codex** | Focused code generation | Implementation, tests, migrations |
| **Gemini** | Analysis + requirements | Design reviews, risk analysis, spec clarification |

## Notes

- Specs are passive docs — only used when the agent is explicitly told to read them.
- Skills are loaded manually per task — agents do not auto-load all skills.
- Re-run bootstrap after adding new skills to propagate them to native folders.
