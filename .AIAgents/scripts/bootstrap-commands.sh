#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'HELP'
Usage:
  ./.AIAgents/scripts/bootstrap-commands.sh [--repo PATH] [--agent AGENT] [--mode copy|link]

Options:
  --repo PATH     Target repository path. Default: current directory.
  --agent AGENT   codex | gemini | claude | all. Default: all.
  --mode MODE     copy | link. Default: copy.
  -h, --help      Show help.

Examples:
  ./.AIAgents/scripts/bootstrap-commands.sh
  ./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/repo --agent claude
  ./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/repo --agent all --mode link
HELP
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_PATH="$(pwd)"
AGENT="all"
MODE="copy"
START_MARK="<!-- .AIAgents Autoload Start -->"
END_MARK="<!-- .AIAgents Autoload End -->"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_PATH="$2"
      shift 2
      ;;
    --agent)
      AGENT="$2"
      shift 2
      ;;
    --mode)
      MODE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$REPO_PATH" ]]; then
  echo "Target repo does not exist: $REPO_PATH" >&2
  exit 1
fi

# Warn if REPO_PATH is inside the module itself (common mistake: running from .AIAgents/)
REPO_PATH="$(cd "$REPO_PATH" && pwd)"
if [[ "$REPO_PATH" == "$MODULE_ROOT" || "$REPO_PATH" == "$MODULE_ROOT"/* ]]; then
  echo "WARNING: --repo points inside the .AIAgents module ($REPO_PATH)." >&2
  echo "  Run from your project root or pass --repo /path/to/your/project" >&2
  exit 1
fi

case "$AGENT" in
  codex|gemini|claude|copilot|all) ;;
  *)
    echo "Invalid --agent value: $AGENT" >&2
    exit 1
    ;;
esac

case "$MODE" in
  copy|link) ;;
  *)
    echo "Invalid --mode value: $MODE" >&2
    exit 1
    ;;
esac

install_files() {
  local src_dir="$1"
  local dest_dir="$2"

  mkdir -p "$dest_dir"

  local file
  for file in "$src_dir"/*.md; do
    [[ -f "$file" ]] || continue
    local base
    base="$(basename "$file")"
    local dest="$dest_dir/$base"

    if [[ "$MODE" == "copy" ]]; then
      cp "$file" "$dest"
    else
      ln -sfn "$file" "$dest"
    fi

    echo "Installed: $dest"
  done
}

install_skills() {
  local src_skills_dir="$1"
  local dest_skills_dir="$2"

  [[ -d "$src_skills_dir" ]] || return 0

  local skill_dir
  for skill_dir in "$src_skills_dir"/*/; do
    [[ -d "$skill_dir" ]] || continue
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local dest="$dest_skills_dir/$skill_name"
    local skill_file="$skill_dir/SKILL.md"

    [[ -f "$skill_file" ]] || continue

    mkdir -p "$dest"

    if [[ "$MODE" == "copy" ]]; then
      cp "$skill_file" "$dest/SKILL.md"
    else
      ln -sfn "$skill_file" "$dest/SKILL.md"
    fi

    echo "Installed skill: $dest/SKILL.md"
  done
}

ensure_project_context() {
  local target_context="$REPO_PATH/.ai/project-context.md"
  local template_context="$MODULE_ROOT/_shared/templates/project-context-template.md"

  mkdir -p "$REPO_PATH/.ai"
  mkdir -p "$REPO_PATH/specs/features"
  mkdir -p "$REPO_PATH/specs/bugs"

  if [[ ! -f "$target_context" ]]; then
    if [[ -f "$template_context" ]]; then
      cp "$template_context" "$target_context"
      echo "Created: $target_context"
    else
      cat > "$target_context" <<'DOC'
# Project Context

TODO: Run `/scan` to populate this file.
DOC
      echo "Created fallback: $target_context"
    fi
  fi
}

ensure_header() {
  local file="$1"
  local header="$2"

  if [[ ! -f "$file" ]]; then
    cat > "$file" <<DOC
# $header
DOC
  fi
}

ensure_autoload_block() {
  local file="$1"
  local block_file="$2"
  local tmp

  tmp="$(mktemp)"

  if grep -qF "$START_MARK" "$file"; then
    awk -v start="$START_MARK" -v end="$END_MARK" -v block_file="$block_file" '
      BEGIN {
        in_block = 0
        replaced = 0
        while ((getline line < block_file) > 0) {
          block = block line "\n"
        }
        close(block_file)
      }
      $0 == start {
        printf "%s", block
        in_block = 1
        replaced = 1
        next
      }
      $0 == end {
        in_block = 0
        next
      }
      !in_block { print }
      END {
        if (!replaced) {
          if (NR > 0) print ""
          printf "%s", block
        }
      }
    ' "$file" > "$tmp"
  else
    cat "$file" > "$tmp"
    if [[ -s "$tmp" ]]; then
      echo "" >> "$tmp"
    fi
    cat "$block_file" >> "$tmp"
  fi

  mv "$tmp" "$file"
}

write_guidance_block() {
  local file="$1"
  local block_file="$2"

  ensure_autoload_block "$file" "$block_file"
  rm -f "$block_file"
}

skill_lines() {
  local skills_path="$1"
  for skill in backend frontend data testing devops; do
    echo "- $skills_path/$skill/SKILL.md"
  done
}

install_codex() {
  install_files "$MODULE_ROOT/Codex/commands" "$REPO_PATH/.codex/commands"
  install_skills "$MODULE_ROOT/Codex/skills" "$REPO_PATH/.codex/skills"

  local file="$REPO_PATH/AGENTS.md"
  ensure_header "$file" "AGENTS Instructions"

  local block_file
  block_file="$(mktemp)"
  cat > "$block_file" <<DOC
$START_MARK
Load command files from .codex/commands/*.md

Domain skills available (load only the skill for your current task):
$(skill_lines ".codex/skills")

Startup behavior (required):
1. Run \`/scan\` first to create/update \`.ai/project-context.md\`.
2. If \`project-context.md\` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the skill matching your domain (backend, frontend, data, testing, devops).
4. Each skill specifies exactly which section of \`project-context.md\` to read — load only that section.
5. If critical info is missing, mark \`NEEDS CLARIFICATION\` and continue with safe defaults.

Recommended execution order:
1. \`/scan\`       → populate .ai/project-context.md
2. \`/spec\`       → define feature requirements — creates specs/features/<slug>/ and sets .ai/current
3. \`/plan\`       → architecture + phased implementation plan (reads .ai/current automatically)
4. \`/tasks\`      → execution task list with dependencies
5. \`/implement\`  → execute tasks domain-by-domain
6. \`/review\`     → validate implementation against spec acceptance criteria
7. \`/skill\`      → create or edit a project-specific skill

Navigation:
- \`/status\`      → pipeline snapshot — stage, task counts, next step
- \`/switch\`      → change active spec without re-running /spec
- \`/fix\`         → minimal bug fix; add --trace for specs/bugs/<slug>/ traceability

Multi-agent workflow:
- Spec phase (/spec + /plan) → best handled by an analysis-focused agent (Gemini, Claude)
- Implementation phase (/implement) → Codex excels at focused code generation per domain task
- Review phase (/review) → Gemini for gap analysis, Codex for test coverage check
- Shared artifact: specs/<type>/<slug>/ — any agent picks up via .ai/current

Bootstrap command:
\`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy\`
$END_MARK
DOC
  write_guidance_block "$file" "$block_file"
}

install_gemini() {
  install_files "$MODULE_ROOT/Gemini/commands" "$REPO_PATH/.gemini/commands"
  install_skills "$MODULE_ROOT/Gemini/skills" "$REPO_PATH/.gemini/skills"

  local file="$REPO_PATH/GEMINI.md"
  ensure_header "$file" "Gemini Instructions"

  local block_file
  block_file="$(mktemp)"
  cat > "$block_file" <<DOC
$START_MARK
Load command files from .gemini/commands/*.md

Domain skills available (load only the skill for your current task):
$(skill_lines ".gemini/skills")

Startup behavior (required):
1. Run \`/scan\` first to create/update \`.ai/project-context.md\`.
2. If \`project-context.md\` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the skill matching your domain (backend, frontend, data, testing, devops).
4. Each skill specifies exactly which section of \`project-context.md\` to read — load only that section.
5. If critical info is missing, mark \`NEEDS CLARIFICATION\` and continue with safe defaults.

Recommended execution order:
1. \`/scan\`       → populate .ai/project-context.md
2. \`/spec\`       → define feature requirements — Gemini excels here (creates .ai/current automatically)
3. \`/plan\`       → architecture + phased implementation plan (reads .ai/current automatically)
4. \`/tasks\`      → execution task list — Gemini surfaces sequencing risks
5. \`/implement\`  → readiness review before handing off to Claude or Codex
6. \`/review\`     → deep gap analysis between spec intent and implementation — Gemini's strength
7. \`/skill\`      → create or edit a project-specific analysis skill

Navigation:
- \`/status\`      → pipeline snapshot with risk assessment
- \`/switch\`      → change active spec; highlights outstanding review issues on switch
- \`/fix\`         → root cause analysis + recommendation; add --trace for bug specs

Multi-agent workflow:
- Spec phase (/spec) → Gemini preferred — surfaces hidden requirements and risks
- Implementation review (/implement) → Gemini validates readiness, hands off to Claude/Codex
- Code review (/review) → Gemini's core strength — behavioral drift, edge case gaps
- Shared artifact: specs/<type>/<slug>/ — any agent picks up via .ai/current

Bootstrap command:
\`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy\`
$END_MARK
DOC
  write_guidance_block "$file" "$block_file"
}

install_claude() {
  install_files "$MODULE_ROOT/Claude/commands" "$REPO_PATH/.claude/commands"
  install_skills "$MODULE_ROOT/Claude/skills" "$REPO_PATH/.claude/skills"

  local file="$REPO_PATH/CLAUDE.md"
  ensure_header "$file" "Claude Instructions"

  if ! grep -qF 'Load command files from `.claude/commands/*.md`.' "$file"; then
    printf '\nLoad command files from `.claude/commands/*.md`.\n' >> "$file"
  fi

  local block_file
  block_file="$(mktemp)"
  cat > "$block_file" <<DOC
$START_MARK
Slash commands (legacy, kept for compatibility):
Load command files from .claude/commands/*.md

Workflow skills — invoke by name to execute a pipeline step:
- scan         → populate .ai/project-context.md
- spec         → define feature requirements (creates .ai/current)
- plan         → architecture + phased implementation plan
- tasks        → execution task list with dependencies
- implement    → execute tasks domain-by-domain with progress tracking
- spec-review  → validate implementation against spec acceptance criteria
- fix          → minimal bug fix (add --trace for bug spec traceability)
- status       → pipeline snapshot — stage, task counts, next step
- switch       → change active spec without re-running spec
- mkskill      → create or update a project-specific skill
- harness      → configure Claude Code hooks and permissions

Domain skills — load only the skill matching your current task:
$(skill_lines ".claude/skills")

Startup behavior (required):
1. Invoke the \`scan\` skill first to create/update \`.ai/project-context.md\`.
2. If \`project-context.md\` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Before any task, load only the domain skill matching your work (backend, frontend, data, testing, devops).
4. Each domain skill specifies exactly which section of \`project-context.md\` to read — load only that section.
5. If critical info is missing, mark \`NEEDS CLARIFICATION\` and continue with safe defaults.

Multi-agent workflow:
- Spec phase (spec + plan) → best handled by an analysis-focused agent (Gemini, Claude)
- Implementation phase (implement) → best handled by a code-generation agent (Claude, Codex)
- Shared artifact: specs/<feature>/ — any agent can hand off to another via these files

Bootstrap command:
\`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy\`
$END_MARK
DOC
  write_guidance_block "$file" "$block_file"
}

install_copilot() {
  local dest_commands="$REPO_PATH/.copilot/commands"
  local dest_skills="$REPO_PATH/.copilot/skills"

  install_files "$MODULE_ROOT/Copilot/commands" "$dest_commands"
  install_skills "$MODULE_ROOT/Copilot/skills" "$dest_skills"

  local file="$REPO_PATH/.github/copilot-instructions.md"
  mkdir -p "$REPO_PATH/.github"
  ensure_header "$file" "Copilot Instructions"

  local block_file
  block_file="$(mktemp)"
  cat > "$block_file" <<DOC
$START_MARK
## Agent context

This project uses a shared multi-agent workflow. All agents read from the same shared artifacts:
- \`.ai/project-context.md\` — repository context (stack, architecture, conventions)
- \`specs/<type>/<slug>/spec.md\` — feature or bug specification
- \`specs/<type>/<slug>/plan.md\` — implementation plan
- \`specs/<type>/<slug>/tasks.md\` — atomic task list
- \`.ai/current\` — path to the active spec directory

## Domain skills (model-agnostic)

Load only the skill matching your current task domain. Open the file and paste its contents into the chat.

- Backend:  \`.copilot/skills/backend/SKILL.md\`
- Frontend: \`.copilot/skills/frontend/SKILL.md\`
- Data:     \`.copilot/skills/data/SKILL.md\`
- Testing:  \`.copilot/skills/testing/SKILL.md\`
- DevOps:   \`.copilot/skills/devops/SKILL.md\`

## Workflow commands (prompt templates)

These are prompt templates — open the file and paste into Copilot Chat to execute the step.

- \`.copilot/commands/scan.md\`      → profile repo and generate \`.ai/project-context.md\`
- \`.copilot/commands/spec.md\`      → define feature or bug requirements
- \`.copilot/commands/plan.md\`      → architecture + phased implementation plan
- \`.copilot/commands/tasks.md\`     → atomic task list with dependencies
- \`.copilot/commands/implement.md\` → execute tasks domain by domain
- \`.copilot/commands/fix.md\`       → minimal bug fix (add --trace for traceability)
- \`.copilot/commands/status.md\`    → pipeline snapshot — stage, task counts, next step
- \`.copilot/commands/switch.md\`    → change active spec without re-running spec

## Startup behavior (required)

1. Run the \`scan\` prompt first to create or update \`.ai/project-context.md\`.
2. Before any task, load only the domain skill matching your work.
3. Each skill specifies exactly which section of \`project-context.md\` to read — load only that section.
4. If critical info is missing, mark \`NEEDS CLARIFICATION\` and continue with safe defaults.

## Multi-agent workflow

- Spec phase (scan + spec + plan): best handled by an analysis-focused agent
- Implementation phase (implement): best handled by a code-generation agent
- Shared artifact: \`specs/<type>/<slug>/\` — any agent can pick up via \`.ai/current\`

## Notes

- Skills and commands are model-agnostic — they work with any model powering Copilot (GPT-4o, Claude, Gemini, etc.)
- Do not auto-load all skills — load only the one matching the current domain task.

Bootstrap command:
\`./.AIAgents/scripts/bootstrap-commands.sh --repo . --agent all --mode copy\`
$END_MARK
DOC
  write_guidance_block "$file" "$block_file"
}

if [[ "$AGENT" == "codex" || "$AGENT" == "all" ]]; then
  install_codex
fi

if [[ "$AGENT" == "gemini" || "$AGENT" == "all" ]]; then
  install_gemini
fi

if [[ "$AGENT" == "claude" || "$AGENT" == "all" ]]; then
  install_claude
fi

if [[ "$AGENT" == "copilot" || "$AGENT" == "all" ]]; then
  install_copilot
fi

ensure_project_context

echo "Done. Installed in $REPO_PATH:"
echo "  .claude/   .codex/   .gemini/   .copilot/   .github/copilot-instructions.md   .ai/project-context.md"
