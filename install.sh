#!/usr/bin/env bash

# AIAgents installer
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh)
#   bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh) --agent claude
#   bash <(curl -fsSL https://raw.githubusercontent.com/DiegoBoni/AIAgents/main/install.sh) --agent all --mode link

set -euo pipefail

REPO_URL="https://github.com/DiegoBoni/AIAgents.git"
TMP_DIR="$(mktemp -d)"
TARGET="$(pwd)"
AGENT="all"
MODE="copy"

# ── parse args ────────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2 ;;
    --mode)  MODE="$2";  shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: install.sh [--agent claude|codex|gemini|all] [--mode copy|link] [--target PATH]"
      exit 0
      ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

# ── validate ──────────────────────────────────────────────────────────────────
case "$AGENT" in codex|gemini|claude|all) ;; *)
  echo "Invalid --agent: $AGENT  (use: claude | codex | gemini | all)" >&2; exit 1 ;;
esac

case "$MODE" in copy|link) ;; *)
  echo "Invalid --mode: $MODE  (use: copy | link)" >&2; exit 1 ;;
esac

if [[ ! -d "$TARGET" ]]; then
  echo "Target directory does not exist: $TARGET" >&2; exit 1
fi

# ── clone ─────────────────────────────────────────────────────────────────────
echo ""
echo "  AIAgents installer"
echo "  ──────────────────"
echo "  Target : $TARGET"
echo "  Agent  : $AGENT"
echo "  Mode   : $MODE"
echo ""

echo "Cloning AIAgents source..."
git clone --quiet --depth 1 "$REPO_URL" "$TMP_DIR"

# ── bootstrap ─────────────────────────────────────────────────────────────────
echo "Running bootstrap..."
bash "$TMP_DIR/.AIAgents/scripts/bootstrap-commands.sh" \
  --repo "$TARGET" \
  --agent "$AGENT" \
  --mode "$MODE"

# ── cleanup ───────────────────────────────────────────────────────────────────
rm -rf "$TMP_DIR"

# ── done ──────────────────────────────────────────────────────────────────────
echo ""
echo "Done. AIAgents installed in: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Open $TARGET in your AI agent"
echo "  2. Run /context  →  scans the repo and populates .ai/project-context.md"
echo "  3. Run /spec <feature description>"
echo "  4. Run /plan  and  /tasks  to build the execution plan"
echo ""
