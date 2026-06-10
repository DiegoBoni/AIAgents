---
name: harness
description: Set up the Claude Code harness for this project — hooks, domain-scoped permissions, and audit logging in .claude/settings.json.
---

# Harness

## Arguments

Optional: `--minimal` for hooks only, `--full` for hooks + permissions + scripts.

## Output

`.claude/settings.json` | `.ai/log/` | `.ai/scripts/on-session-end.sh`

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

## Rules

- Never add `deny` rules for paths that domain skills legitimately need
- If test command is `NEEDS CLARIFICATION`, skip the Stop hook and note it
- Permissions are additive — if settings.json already has entries, append don't replace
- This skill is Claude Code only — Codex and Gemini do not use settings.json
