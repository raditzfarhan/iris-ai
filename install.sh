#!/bin/bash
# IRIS installer — always pulls latest files from GitHub
#
# Usage:
#   bash install.sh [target] [--force]
#
# --force   Overwrite existing files. Default is to skip files that already exist.

set -e

GITHUB_USER="raditzfarhan"
GITHUB_REPO="iris-ai"
GITHUB_BRANCH="main"
GITHUB_RAW="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH"

TARGET="."
FORCE=0

for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=1 ;;
    *) TARGET="$arg" ;;
  esac
done

FILES=(
  ".claude/commands/iris.md"
  ".claude/commands/ali.md"
  ".claude/commands/alicia.md"
  ".claude/commands/bakar.md"
  ".claude/commands/rizwan.md"
  ".claude/commands/rama.md"
  ".claude/commands/comot.md"
  "agents/iris-agent.md"
  "agents/ali-agent.md"
  "agents/alicia-agent.md"
  "agents/bakar-agent.md"
  "agents/rizwan-agent.md"
  "agents/rama-agent.md"
  "agents/comot-agent.md"
  "skills/iris-brief/SKILL.md"
  "skills/iris-spec/SKILL.md"
  "skills/iris-plan/SKILL.md"
  "skills/iris-ops/SKILL.md"
  "skills/iris-debrief/SKILL.md"
)

echo "Installing IRIS into: $TARGET"
[ "$FORCE" = "1" ] && echo "Mode: overwrite (--force)" || echo "Mode: skip existing files (use --force to overwrite)"
echo ""

# Create directories
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/agents"
mkdir -p "$TARGET/skills/iris-brief"
mkdir -p "$TARGET/skills/iris-spec"
mkdir -p "$TARGET/skills/iris-plan"
mkdir -p "$TARGET/skills/iris-ops"
mkdir -p "$TARGET/skills/iris-debrief"
mkdir -p "$TARGET/.iris-ai/outputs/briefs"
mkdir -p "$TARGET/.iris-ai/outputs/tasks"
mkdir -p "$TARGET/.iris-ai/outputs/docs"

INSTALLED=0
SKIPPED=0

if ! command -v curl &>/dev/null; then
  echo "Error: curl is required" >&2
  exit 1
fi

echo "Source: github.com/$GITHUB_USER/$GITHUB_REPO @ $GITHUB_BRANCH"

install_file() {
  local file="$1"
  local dest="$TARGET/$file"

  if [ -f "$dest" ] && [ "$FORCE" = "0" ]; then
    echo "  skip     $file"
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  curl -sSfL "$GITHUB_RAW/$file" -o "$dest"
  echo "  install  $file"
  INSTALLED=$((INSTALLED + 1))
}

echo ""
for file in "${FILES[@]}"; do
  install_file "$file"
done

echo ""
echo "Done. $INSTALLED installed, $SKIPPED skipped."
echo ""
echo "Usage:"
echo "  /iris <idea>     — start a new mission from scratch"
echo "  /iris spec       — jump to spec (brief must exist)"
echo "  /iris plan       — jump to plan (spec must be confirmed)"
echo "  /iris ops        — jump to ops (plan must be confirmed)"
echo "  /iris debrief    — wrap up completed implementation"
