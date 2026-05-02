#!/bin/bash
# IRIS installer — pulls latest files from GitHub
#
# Usage:
#   bash install.sh [target] [options]
#
# Options:
#   --force, -f       Overwrite existing files (default: skip)
#   --global, -g      Install to global tool directories (e.g. ~/.claude/)
#   --tool=<name>     Skip menu, install for one tool only (claude|cursor|windsurf|opencode|fallback)
#
# Examples:
#   bash install.sh .                        # project install, auto-detect tool(s)
#   bash install.sh . --global               # global install
#   bash install.sh . --tool=cursor          # project install for Cursor only
#   bash install.sh . --force                # overwrite existing files
#   bash install.sh . --global --force       # global install, overwrite

set -e

GITHUB_USER="raditzfarhan"
GITHUB_REPO="iris-ai"
GITHUB_BRANCH="main"
GITHUB_RAW="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH"

TARGET="."
FORCE=0
GLOBAL=0
TOOL_OVERRIDE=""

for arg in "$@"; do
  case "$arg" in
    --force|-f)   FORCE=1 ;;
    --global|-g)  GLOBAL=1 ;;
    --tool=*)     TOOL_OVERRIDE="${arg#--tool=}" ;;
    *)            TARGET="$arg" ;;
  esac
done

VALID_TOOLS=("claude" "cursor" "windsurf" "opencode" "fallback")

if [ -n "$TOOL_OVERRIDE" ]; then
  valid=0
  for t in "${VALID_TOOLS[@]}"; do
    [ "$t" = "$TOOL_OVERRIDE" ] && valid=1 && break
  done
  if [ "$valid" = "0" ]; then
    echo "Unknown tool: $TOOL_OVERRIDE" >&2
    echo "Valid tools: claude, cursor, windsurf, opencode, fallback" >&2
    exit 1
  fi
fi

# ── Colors (disabled when not writing to a terminal) ─────────────────────────
if [ -t 1 ]; then
  CYAN='\033[0;36m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  RED_B='\033[1;31m'
  BLUE_B='\033[1;34m'
  DIM='\033[2m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  CYAN='' GREEN='' YELLOW='' RED='' RED_B='' BLUE_B='' DIM='' BOLD='' NC=''
fi

# ── Tool registry ─────────────────────────────────────────────────────────────
ALL_TOOLS=("claude" "cursor" "windsurf" "opencode")

# ── Tool detection ────────────────────────────────────────────────────────────
# Returns 0 (true) if tool is detected, 1 (false) if not.
# Detection is always project-scoped regardless of --global.
is_detected() {
  local tool="$1"
  case "$tool" in
    claude)   command -v claude &>/dev/null 2>&1 || [ -d "$TARGET/.claude" ] ;;
    cursor)   command -v cursor &>/dev/null 2>&1 || [ -d "$TARGET/.cursor" ] ;;
    windsurf) command -v windsurf &>/dev/null 2>&1 || [ -d "$TARGET/.windsurf" ] ;;
    opencode) command -v opencode &>/dev/null 2>&1 || [ -d "$TARGET/.opencode" ] ;;
    *)        return 1 ;;
  esac
}

# ── Path resolution ───────────────────────────────────────────────────────────
# Sets TOOL_SKILLS_DIR, TOOL_AGENTS_DIR, TOOL_COMMANDS_DIR for a given tool.
# Usage: tool_paths <tool> <global=0|1>
tool_paths() {
  local tool="$1"
  local global="${2:-0}"

  case "$tool" in
    claude)
      if [ "$global" = "1" ]; then
        TOOL_SKILLS_DIR="$HOME/.claude/skills"
        TOOL_AGENTS_DIR="$HOME/.claude/agents"
        TOOL_COMMANDS_DIR="$HOME/.claude/commands"
      else
        TOOL_SKILLS_DIR="$TARGET/.claude/skills"
        TOOL_AGENTS_DIR="$TARGET/.claude/agents"
        TOOL_COMMANDS_DIR="$TARGET/.claude/commands"
      fi ;;
    cursor)
      if [ "$global" = "1" ]; then
        TOOL_SKILLS_DIR="$HOME/.cursor/skills"
        TOOL_AGENTS_DIR="$HOME/.cursor/agents"
        TOOL_COMMANDS_DIR="$HOME/.cursor/rules"
      else
        TOOL_SKILLS_DIR="$TARGET/.cursor/skills"
        TOOL_AGENTS_DIR="$TARGET/.cursor/agents"
        TOOL_COMMANDS_DIR="$TARGET/.cursor/rules"
      fi ;;
    windsurf)
      if [ "$global" = "1" ]; then
        TOOL_SKILLS_DIR="$HOME/.windsurf/skills"
        TOOL_AGENTS_DIR="$HOME/.windsurf/agents"
        TOOL_COMMANDS_DIR="$HOME/.windsurf/rules"
      else
        TOOL_SKILLS_DIR="$TARGET/.windsurf/skills"
        TOOL_AGENTS_DIR="$TARGET/.windsurf/agents"
        TOOL_COMMANDS_DIR="$TARGET/.windsurf/rules"
      fi ;;
    opencode)
      if [ "$global" = "1" ]; then
        TOOL_SKILLS_DIR="$HOME/.config/opencode/skills"
        TOOL_AGENTS_DIR="$HOME/.config/opencode/agents"
        TOOL_COMMANDS_DIR="$HOME/.config/opencode/rules"
      else
        TOOL_SKILLS_DIR="$TARGET/.opencode/skills"
        TOOL_AGENTS_DIR="$TARGET/.opencode/agents"
        TOOL_COMMANDS_DIR="$TARGET/.opencode/rules"
      fi ;;
    fallback)
      if [ "$global" = "1" ]; then
        TOOL_SKILLS_DIR="$HOME/.ai/skills"
        TOOL_AGENTS_DIR="$HOME/.ai/agents"
        TOOL_COMMANDS_DIR="$HOME/.ai/commands"
      else
        TOOL_SKILLS_DIR="$TARGET/.ai/skills"
        TOOL_AGENTS_DIR="$TARGET/.ai/agents"
        TOOL_COMMANDS_DIR="$TARGET/.ai/commands"
      fi ;;
  esac
}

# ── File lists ────────────────────────────────────────────────────────────────
COMMAND_FILES=(
  ".claude/commands/iris.md"
  ".claude/commands/probe.md"
  ".claude/commands/audit.md"
  ".claude/commands/strategy.md"
)

AGENT_FILES=(
  "agents/iris-agent.md"
  "agents/probe-agent.md"
  "agents/audit-agent.md"
  "agents/strategy-agent.md"
)

SKILL_FILES=(
  "skills/iris-brief/SKILL.md"
  "skills/iris-spec/SKILL.md"
  "skills/iris-plan/SKILL.md"
  "skills/iris-ops/SKILL.md"
  "skills/iris-debrief/SKILL.md"
)

# ── ASCII art + header ────────────────────────────────────────────────────────
# I=blue, R=red, I=blue, S=red — Ejen Ali's costume colours
echo ""
echo -e "  ${BLUE_B}██╗${RED_B}██████╗ ${BLUE_B}██╗${RED_B}███████╗${NC}"
echo -e "  ${BLUE_B}██║${RED_B}██╔══██╗${BLUE_B}██║${RED_B}██╔════╝${NC}"
echo -e "  ${BLUE_B}██║${RED_B}██████╔╝${BLUE_B}██║${RED_B}███████╗${NC}"
echo -e "  ${BLUE_B}██║${RED_B}██╔══██╗${BLUE_B}██║${RED_B}╚════██║${NC}"
echo -e "  ${BLUE_B}██║${RED_B}██║  ██║${BLUE_B}██║${RED_B}███████║${NC}"
echo -e "  ${BLUE_B}╚═╝${RED_B}╚═╝  ╚═╝${BLUE_B}╚═╝${RED_B}╚══════╝${NC}"
echo -e "${DIM}  Dev Workflow Suite for AI Coding Tools${NC}"
echo ""

TOOLS_LABEL=$(IFS=', '; echo "${DETECTED_TOOLS[*]}")
DETECT_LABEL=$( [ -n "$TOOL_OVERRIDE" ] && echo "(forced)" || echo "(detected)" )
if [ ${#DETECTED_TOOLS[@]} -eq 1 ]; then
  echo -e "  ${BOLD}Tool:${NC}   $TOOLS_LABEL $DETECT_LABEL"
else
  echo -e "  ${BOLD}Tools:${NC}  $TOOLS_LABEL $DETECT_LABEL"
fi
if [ "$GLOBAL" = "1" ]; then
  echo -e "  ${BOLD}Scope:${NC}  global (~/.ai/)"
else
  echo -e "  ${BOLD}Target:${NC} $TARGET"
fi
echo -e "  ${BOLD}Mode:${NC}   $( [ "$FORCE" = "1" ] && echo "overwrite (--force)" || echo "skip existing (--force to overwrite)" )"
echo ""

if ! command -v curl &>/dev/null; then
  echo -e "${RED}Error: curl is required${NC}" >&2
  exit 1
fi

echo -e "${DIM}  Source: github.com/$GITHUB_USER/$GITHUB_REPO @ $GITHUB_BRANCH${NC}"
echo ""

INSTALLED=0
SKIPPED=0

# ── Install helper ────────────────────────────────────────────────────────────
fetch_file() {
  local src="$1"
  local dest="$2"

  if [ -f "$dest" ] && [ "$FORCE" = "0" ]; then
    echo -e "  ${DIM}skip     $dest${NC}"
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  mkdir -p "$(dirname "$dest")"
  curl -sSfL "$GITHUB_RAW/$src" -o "$dest"
  echo -e "  ${GREEN}install${NC}  $dest"
  INSTALLED=$((INSTALLED + 1))
}

# ── Commands (one set per tool that supports slash commands) ──────────────────
if [ ${#COMMAND_DIRS[@]} -gt 0 ]; then
  for cmd_dir in "${COMMAND_DIRS[@]}"; do
    echo -e "${YELLOW}Commands${NC} → $cmd_dir"
    for file in "${COMMAND_FILES[@]}"; do
      filename="${file##*/}"
      fetch_file "$file" "$cmd_dir/$filename"
    done
    echo ""
  done
fi

# ── Agents (shared across all tools) ─────────────────────────────────────────
echo -e "${YELLOW}Agents${NC} → $AGENTS_DIR"
for file in "${AGENT_FILES[@]}"; do
  filename="${file##*/}"
  fetch_file "$file" "$AGENTS_DIR/$filename"
done
echo ""

# ── Skills (shared across all tools) ─────────────────────────────────────────
echo -e "${YELLOW}Skills${NC} → $SKILLS_BASE"
for file in "${SKILL_FILES[@]}"; do
  subdir="$(echo "$file" | cut -d'/' -f2)"
  fetch_file "$file" "$SKILLS_BASE/$subdir/SKILL.md"
done
echo ""

# ── Project-level files (always in the project, never global) ─────────────────
if [ "$GLOBAL" = "0" ]; then
  mkdir -p "$TARGET/.iris-ai/outputs/briefs"
  mkdir -p "$TARGET/.iris-ai/outputs/tasks"
  mkdir -p "$TARGET/.iris-ai/outputs/docs"

  echo -e "${YELLOW}Project files${NC} → $TARGET/.iris-ai"
  fetch_file "AGENTS.md" "$TARGET/.iris-ai/AGENTS.md"
  fetch_file "CLAUDE.md" "$TARGET/.iris-ai/CLAUDE.md"
  echo -e "  ${CYAN}create${NC}   $TARGET/.iris-ai/outputs/{briefs,tasks,docs}"
  echo ""
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo -e "${GREEN}${BOLD}Done.${NC} $INSTALLED installed, $SKIPPED skipped."
echo ""
echo -e "${BOLD}Usage:${NC}"
echo -e "  ${CYAN}/iris <idea>${NC}      — start a new mission from scratch"
echo -e "  ${CYAN}/iris spec${NC}        — jump to spec (brief must exist)"
echo -e "  ${CYAN}/iris plan${NC}        — jump to plan (spec must be confirmed)"
echo -e "  ${CYAN}/iris ops${NC}         — jump to ops (plan must be confirmed)"
echo -e "  ${CYAN}/iris debrief${NC}     — wrap up completed implementation"
echo -e "  ${CYAN}/probe <error>${NC}    — investigate broken behaviour"
echo -e "  ${CYAN}/audit <target>${NC}   — security and architecture audit"
echo -e "  ${CYAN}/strategy <plan>${NC}  — strategic direction review"
