---
description: Set up the Claude Code harness for this project — hooks, domain-scoped permissions, and audit logging.
arguments: (optional) --minimal for hooks only, --full for hooks + permissions + scripts
output: .claude/settings.json  |  .ai/log/  |  .ai/scripts/on-session-end.sh
agent_role: orchestrator (Claude Code only — hooks and settings are Claude-specific)
---

## User Input

```text
$ARGUMENTS
```

## Goal

Wire the Claude Code harness into this project so every agent session is:
- **Audited** — file changes logged to `.ai/log/session.log`
- **Guarded** — permissions scoped to what each domain skill actually needs
- **Recoverable** — session-end hook runs tests and flags failures before closing

## Steps

1. Read `.ai/project-context.md` to extract:
   - Test command (from `[context.testing]` — e.g. `npm test`, `pytest`, `go test ./...`)
   - Source directories per domain (from stack/architecture sections)
   - CI gate criteria (from `[context.testing]`)
2. Read existing `.claude/settings.json` if present — merge rather than overwrite.
3. Generate `.claude/settings.json` with:

   **Hooks:**
   - `PostToolUse` on `Write|Edit|MultiEdit` → append entry to `.ai/log/session.log`
   - `PostToolUse` on `Bash` → log commands that match `test|lint|build` patterns
   - `Stop` → run `.ai/scripts/on-session-end.sh` if it exists

   **Permissions (--full only):**
   - Allow: `Bash(git *)`, `Bash(<test-command> *)`, `Bash(<lint-command> *)`
   - Allow: `Read(**)`, `Edit(<src-dirs>/**)`
   - Domain-scoped edit permissions per skill (backend → src/api/**, frontend → src/components/**, etc.)

4. Create `.ai/log/` directory with a `.gitkeep` and a `.gitignore` that keeps the dir but ignores `*.log` files.
5. Create `.ai/scripts/on-session-end.sh`:
   ```bash
   #!/usr/bin/env bash
   # Runs after every Claude Code session
   # Add: test run, lint check, commit prompt, etc.
   echo "Session ended: $(date)" >> .ai/log/session.log
   ```
6. Return: paths created/updated + summary of permissions configured + any manual steps needed.

## settings.json structure

```json
{
  "permissions": {
    "allow": [
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(git status)",
      "Bash(<test-command>)",
      "Bash(<lint-command>)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [{
          "type": "command",
          "command": "mkdir -p .ai/log && echo \"$(date '+%Y-%m-%d %H:%M:%S') | EDIT | $CLAUDE_TOOL_INPUT_FILE_PATH\" >> .ai/log/session.log 2>/dev/null || true"
        }]
      }
    ],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "[ -f .ai/scripts/on-session-end.sh ] && bash .ai/scripts/on-session-end.sh || true"
      }]
    }]
  }
}
```

## Audit log format (.ai/log/session.log)

```
2026-05-20 14:32:01 | EDIT   | src/api/checkout.ts
2026-05-20 14:32:15 | EDIT   | src/api/checkout.test.ts
2026-05-20 14:33:00 | STOP   | session ended
```

## Re-running

Safe to re-run at any time. Merges with existing `settings.json` — never overwrites manually added config.
Use `--full` to add domain-scoped permissions on top of a `--minimal` base.

## Rules

- Never add `deny` rules for paths that domain skills legitimately need
- If test command is `NEEDS CLARIFICATION`, skip the Stop hook and note it
- Permissions are additive — if settings.json already has entries, append don't replace
- This command is Claude Code only — Codex and Gemini do not use settings.json
