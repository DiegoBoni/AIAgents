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

case "$AGENT" in
  codex|gemini|claude|all) ;;
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

ensure_project_context() {
  local target_context="$REPO_PATH/.AIAgents/project-context.md"
  local template_context="$MODULE_ROOT/_shared/templates/project-context-template.md"

  mkdir -p "$REPO_PATH/.AIAgents"

  if [[ ! -f "$target_context" ]]; then
    if [[ -f "$template_context" ]]; then
      cp "$template_context" "$target_context"
      echo "Created: $target_context"
    else
      cat > "$target_context" <<'DOC'
# Project Context

TODO: Run `cmd.context` to populate this file.
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

install_guidance() {
  local file="$1"
  local title="$2"
  local command_path="$3"

  ensure_header "$file" "$title"

  local block_file
  block_file="$(mktemp)"

  cat > "$block_file" <<DOC
$START_MARK
Load command files from \
\
\
$command_path

Startup behavior (required):
1. Run \`cmd.context\` first to create/update \`.AIAgents/project-context.md\`.
2. If \`project-context.md\` already exists, refresh it when stack, architecture, integrations, or standards change.
3. Use \`project-context.md\` as source of truth before planning or coding.
4. If critical info is missing, mark \`NEEDS CLARIFICATION\` and continue with safe defaults.

Recommended execution order:
1. \`cmd.context\`
2. \`cmd.specify\`
3. \`cmd.plan\`
4. \`cmd.tasks\`

Bootstrap command:
\`./.AIAgents/scripts/bootstrap-commands.sh --repo $REPO_PATH --agent all --mode copy\`
$END_MARK
DOC

  ensure_autoload_block "$file" "$block_file"
  rm -f "$block_file"
}

install_codex() {
  install_files "$MODULE_ROOT/Codex/commands" "$REPO_PATH/.AIAgents/.codex/commands"
  install_guidance "$REPO_PATH/AGENTS.md" "AGENTS Instructions" ".AIAgents/.codex/commands/*.md"
}

install_gemini() {
  install_files "$MODULE_ROOT/Gemini/commands" "$REPO_PATH/.AIAgents/.gemini/commands"
  install_guidance "$REPO_PATH/GEMINI.md" "Gemini Instructions" ".AIAgents/.gemini/commands/*.md"
}

install_claude() {
  install_files "$MODULE_ROOT/Claude/commands" "$REPO_PATH/.AIAgents/.claude/commands"
  install_guidance "$REPO_PATH/CLAUDE.md" "Claude Instructions" ".AIAgents/.claude/commands/*.md"
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

ensure_project_context

echo "Done. Agent commands installed in: $REPO_PATH/.AIAgents"
