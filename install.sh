#!/bin/bash
# IRIS installer — pulls latest files from GitHub
#
# Usage:
#   bash install.sh [target] [options]
#
# Options:
#   --force, -f       Overwrite existing files (default: skip)
#   --global, -g      Install skills and agents to the tool's global directory
#   --tool=<name>     Override tool detection (claude|cursor|opencode|windsurf)
#
# Examples:
#   bash install.sh .                        # project install, auto-detect tool
#   bash install.sh . --global               # global install, auto-detect tool
#   bash install.sh . --tool=cursor          # project install for Cursor
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

# ── Colors (disabled when not writing to a terminal) ─────────────────────────
if [ -t 1 ]; then
  CYAN='\033[0;36m'
  CYAN_B='\033[1;36m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  RED_B='\033[1;31m'
  BLUE_B='\033[1;34m'
  DIM='\033[2m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  CYAN='' CYAN_B='' GREEN='' YELLOW='' RED='' RED_B='' BLUE_B='' DIM='' BOLD='' NC=''
fi

# ── Tool detection ────────────────────────────────────────────────────────────
detect_tool() {
  if [ -n "$TOOL_OVERRIDE" ]; then echo "$TOOL_OVERRIDE"; return; fi
  if command -v claude &>/dev/null 2>&1 || [ -d "$TARGET/.claude" ]; then echo "claude";   return; fi
  if [ -d "$TARGET/.cursor" ]   || command -v cursor    &>/dev/null 2>&1; then echo "cursor";   return; fi
  if [ -d "$TARGET/.opencode" ] || command -v opencode  &>/dev/null 2>&1; then echo "opencode"; return; fi
  if [ -d "$TARGET/.windsurf" ] || command -v windsurf  &>/dev/null 2>&1; then echo "windsurf"; return; fi
  echo "fallback"
}

TOOL=$(detect_tool)

# ── Path resolution ───────────────────────────────────────────────────────────
INSTALL_COMMANDS=0

case "$TOOL" in
  claude)
    INSTALL_COMMANDS=1
    if [ "$GLOBAL" = "1" ]; then
      COMMANDS_DIR="$HOME/.claude/commands"
      SKILLS_BASE="$HOME/.claude/skills"
      AGENTS_DIR="$HOME/.claude/agents"
    else
      COMMANDS_DIR="$TARGET/.claude/commands"
      SKILLS_BASE="$TARGET/.claude/skills"
      AGENTS_DIR="$TARGET/.claude/agents"
    fi
    ;;
  cursor)
    if [ "$GLOBAL" = "1" ]; then
      SKILLS_BASE="$HOME/.cursor/skills"
      AGENTS_DIR="$HOME/.cursor/agents"
    else
      SKILLS_BASE="$TARGET/.cursor/skills"
      AGENTS_DIR="$TARGET/.cursor/agents"
    fi
    ;;
  opencode)
    if [ "$GLOBAL" = "1" ]; then
      SKILLS_BASE="$HOME/.opencode/skills"
      AGENTS_DIR="$HOME/.opencode/agents"
    else
      SKILLS_BASE="$TARGET/.opencode/skills"
      AGENTS_DIR="$TARGET/.opencode/agents"
    fi
    ;;
  windsurf)
    if [ "$GLOBAL" = "1" ]; then
      SKILLS_BASE="$HOME/.windsurf/skills"
      AGENTS_DIR="$HOME/.windsurf/agents"
    else
      SKILLS_BASE="$TARGET/.windsurf/skills"
      AGENTS_DIR="$TARGET/.windsurf/agents"
    fi
    ;;
  *)
    if [ "$GLOBAL" = "1" ]; then
      SKILLS_BASE="$HOME/.ai/skills"
      AGENTS_DIR="$HOME/.ai/agents"
    else
      SKILLS_BASE="$TARGET/.ai/skills"
      AGENTS_DIR="$TARGET/.ai/agents"
    fi
    ;;
esac

# ── File lists ────────────────────────────────────────────────────────────────
COMMAND_FILES=(
  ".claude/commands/iris.md"
  ".claude/commands/ali.md"
  ".claude/commands/alicia.md"
  ".claude/commands/bakar.md"
  ".claude/commands/rizwan.md"
  ".claude/commands/rama.md"
  ".claude/commands/comot.md"
)

AGENT_FILES=(
  "agents/iris-agent.md"
  "agents/ali-agent.md"
  "agents/alicia-agent.md"
  "agents/bakar-agent.md"
  "agents/rizwan-agent.md"
  "agents/rama-agent.md"
  "agents/comot-agent.md"
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

echo -e "  ${BOLD}Tool:${NC}   $TOOL$( [ -n "$TOOL_OVERRIDE" ] && echo " (forced)" || echo " (detected)" )"
if [ "$GLOBAL" = "1" ]; then
  echo -e "  ${BOLD}Scope:${NC}  global"
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

# ── Commands (Claude only) ────────────────────────────────────────────────────
if [ "$INSTALL_COMMANDS" = "1" ]; then
  echo -e "${YELLOW}Commands:${NC}"
  for file in "${COMMAND_FILES[@]}"; do
    filename="${file##*/}"
    fetch_file "$file" "$COMMANDS_DIR/$filename"
  done
  echo ""
fi

# ── Agents ────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}Agents${NC} → $AGENTS_DIR"
for file in "${AGENT_FILES[@]}"; do
  filename="${file##*/}"
  fetch_file "$file" "$AGENTS_DIR/$filename"
done
echo ""

# ── Skills ────────────────────────────────────────────────────────────────────
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
echo -e "  ${CYAN}/iris <idea>${NC}     — start a new mission from scratch"
echo -e "  ${CYAN}/iris spec${NC}       — jump to spec (brief must exist)"
echo -e "  ${CYAN}/iris plan${NC}       — jump to plan (spec must be confirmed)"
echo -e "  ${CYAN}/iris ops${NC}        — jump to ops (plan must be confirmed)"
echo -e "  ${CYAN}/iris debrief${NC}    — wrap up completed implementation"
