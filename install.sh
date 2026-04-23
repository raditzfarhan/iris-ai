#!/bin/bash
# IRIS installer — copies IRIS workflow files into any Claude Code project

set -e

IRIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-.}"

echo "Installing IRIS into: $TARGET"

# Create target directories
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/skills/iris-brief"
mkdir -p "$TARGET/skills/iris-spec"
mkdir -p "$TARGET/skills/iris-plan"
mkdir -p "$TARGET/skills/iris-ops"
mkdir -p "$TARGET/skills/iris-debrief"
mkdir -p "$TARGET/agents"
mkdir -p "$TARGET/outputs/briefs"
mkdir -p "$TARGET/outputs/tasks"
mkdir -p "$TARGET/outputs/docs"

# Copy command
cp "$IRIS_DIR/.claude/commands/iris.md" "$TARGET/.claude/commands/iris.md"

# Copy skills
cp "$IRIS_DIR/skills/iris-brief/SKILL.md" "$TARGET/skills/iris-brief/SKILL.md"
cp "$IRIS_DIR/skills/iris-spec/SKILL.md" "$TARGET/skills/iris-spec/SKILL.md"
cp "$IRIS_DIR/skills/iris-plan/SKILL.md" "$TARGET/skills/iris-plan/SKILL.md"
cp "$IRIS_DIR/skills/iris-ops/SKILL.md" "$TARGET/skills/iris-ops/SKILL.md"
cp "$IRIS_DIR/skills/iris-debrief/SKILL.md" "$TARGET/skills/iris-debrief/SKILL.md"

# Copy agent
cp "$IRIS_DIR/agents/iris-agent.md" "$TARGET/agents/iris-agent.md"

echo ""
echo "IRIS installed successfully."
echo ""
echo "Usage:"
echo "  /iris <idea>     — start a new mission from scratch"
echo "  /iris spec       — jump to spec (brief must exist)"
echo "  /iris plan       — jump to plan (spec must be confirmed)"
echo "  /iris ops        — jump to ops (plan must be confirmed)"
echo "  /iris debrief    — wrap up completed implementation"
