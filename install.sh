#!/bin/bash
# IRIS installer — installs IRIS into any Claude Code project
# Supports local install (from a clone) and remote install (via curl from GitHub)

set -e

GITHUB_USER="raditzfarhan"
GITHUB_REPO="iris-ai"
GITHUB_BRANCH="main"
GITHUB_RAW="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH"

TARGET="${1:-.}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

FILES=(
  ".claude/commands/iris.md"
  "agents/iris-agent.md"
  "skills/iris-brief/SKILL.md"
  "skills/iris-spec/SKILL.md"
  "skills/iris-plan/SKILL.md"
  "skills/iris-ops/SKILL.md"
  "skills/iris-debrief/SKILL.md"
)

echo "Installing IRIS into: $TARGET"
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

if [ -f "$SCRIPT_DIR/agents/iris-agent.md" ]; then
  # Local install — copy from the repo clone
  echo "Source: local ($SCRIPT_DIR)"
  for file in "${FILES[@]}"; do
    cp "$SCRIPT_DIR/$file" "$TARGET/$file"
  done
else
  # Remote install — download from GitHub
  echo "Source: github.com/$GITHUB_USER/$GITHUB_REPO @ $GITHUB_BRANCH"
  if ! command -v curl &>/dev/null; then
    echo "Error: curl is required for remote install" >&2
    exit 1
  fi
  for file in "${FILES[@]}"; do
    echo "  Downloading $file"
    curl -sSfL "$GITHUB_RAW/$file" -o "$TARGET/$file"
  done
fi

echo ""
echo "IRIS installed successfully."
echo ""
echo "Usage:"
echo "  /iris <idea>     — start a new mission from scratch"
echo "  /iris spec       — jump to spec (brief must exist)"
echo "  /iris plan       — jump to plan (spec must be confirmed)"
echo "  /iris ops        — jump to ops (plan must be confirmed)"
echo "  /iris debrief    — wrap up completed implementation"
