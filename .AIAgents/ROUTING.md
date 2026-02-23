# Agent Routing Guide

Folder names alone are not enough. Each agent needs explicit configuration to discover where skills and commands live.

## Suggested mapping

- Codex skills -> `.AIAgents/Codex/skills/*/SKILL.md`
- Codex commands (source) -> `.AIAgents/Codex/commands/*.md`
- Codex commands (native) -> `.AIAgents/.codex/commands/*.md`
- Gemini skills -> `.AIAgents/Gemini/skills/*/SKILL.md`
- Gemini commands (source) -> `.AIAgents/Gemini/commands/*.md`
- Gemini commands (native) -> `.AIAgents/.gemini/commands/*.md`
- Claude skills -> `.AIAgents/Claude/skills/*/SKILL.md`
- Claude commands (source) -> `.AIAgents/Claude/commands/*.md`
- Claude commands (native) -> `.AIAgents/.claude/commands/*.md`

## How to make it work

1. Configure each agent runtime to scan only its own folder.
2. Keep each skill as its own directory containing `SKILL.md`.
3. Keep each command as a single markdown command file.
4. Store shared templates in `.AIAgents/_shared/templates` and copy/adapt per agent.

## Notes

- If an agent has no native command loader, add bootstrap instructions in that environment to read these files.
- Specs are passive docs; they are used only if prompts/instructions tell the agent to read them.
