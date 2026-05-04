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
#   bash install.sh .                        # project install, auto-detect + interactive menu
#   bash install.sh . --global               # global install, interactive menu
#   bash install.sh . --tool=cursor          # project install for Cursor only (no menu)
#   bash install.sh . --tool=claude,cursor   # NOT supported — run twice
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

# ── Interactive checkbox menu ─────────────────────────────────────────────────
# Populates SELECTED_TOOLS array. Requires a TTY.
# Pre-checks any tool where is_detected() returns true.
show_menu() {
  local -a tools=("${ALL_TOOLS[@]}")
  local -a checked=()
  local cursor_pos=0
  local i key

  # Initialise checked state from detection
  for i in "${!tools[@]}"; do
    if is_detected "${tools[$i]}"; then
      checked[$i]=1
    else
      checked[$i]=0
    fi
  done

  # Restore terminal on interrupt or exit
  _menu_cleanup() { tput cnorm; }
  trap _menu_cleanup EXIT INT

  tput civis  # hide cursor

  _draw_menu() {
    local j
    for j in "${!tools[@]}"; do
      if [ "$j" = "$cursor_pos" ]; then
        printf "  \033[1m▶\033[0m "
      else
        printf "    "
      fi
      if [ "${checked[$j]}" = "1" ]; then
        printf "[x] %-10s" "${tools[$j]}"
      else
        printf "[ ] %-10s" "${tools[$j]}"
      fi
      if is_detected "${tools[$j]}"; then printf " ${DIM}(detected)${NC}"; fi
      printf "\n"
    done
    tput cuu ${#tools[@]}  # move cursor back to top of menu
  }

  echo ""
  echo -e "  Select AI tools to install for:"
  echo -e "  ──────────────────────────────────"
  # Reserve lines for menu rows
  for i in "${!tools[@]}"; do printf "\n"; done
  _draw_menu
  tput cud ${#tools[@]}
  echo -e "  ──────────────────────────────────"
  echo -e "  ${DIM}↑↓/jk navigate  Space toggle  Enter confirm  a all  n none${NC}"
  tput cuu $((${#tools[@]} + 2))

  while true; do
    IFS= read -rsn1 key 2>/dev/null
    case "$key" in
      $'\x1b')
        read -rsn2 -t 0.1 seq 2>/dev/null
        case "$seq" in
          '[A') cursor_pos=$(( (cursor_pos - 1 + ${#tools[@]}) % ${#tools[@]} )) ;;
          '[B') cursor_pos=$(( (cursor_pos + 1) % ${#tools[@]} )) ;;
        esac ;;
      k) cursor_pos=$(( (cursor_pos - 1 + ${#tools[@]}) % ${#tools[@]} )) ;;
      j) cursor_pos=$(( (cursor_pos + 1) % ${#tools[@]} )) ;;
      ' ')
        if [ "${checked[$cursor_pos]}" = "1" ]; then
          checked[$cursor_pos]=0
        else
          checked[$cursor_pos]=1
        fi ;;
      a) for i in "${!tools[@]}"; do checked[$i]=1; done ;;
      n) for i in "${!tools[@]}"; do checked[$i]=0; done ;;
      '') break ;;  # Enter
    esac
    _draw_menu
  done

  tput cud ${#tools[@]}
  printf "\n"
  tput cnorm
  trap - EXIT INT

  SELECTED_TOOLS=()
  for i in "${!tools[@]}"; do
    [ "${checked[$i]}" = "1" ] && SELECTED_TOOLS+=("${tools[$i]}")
  done

  if [ ${#SELECTED_TOOLS[@]} -eq 0 ]; then
    echo -e "  ${DIM}No tool selected — installing to .ai/${NC}"
    SELECTED_TOOLS=("fallback")
  fi
}

# ── File lists ────────────────────────────────────────────────────────────────
COMMAND_FILES=(
  "commands/iris.md"
  "commands/probe.md"
  "commands/audit.md"
  "commands/strategy.md"
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
# 256-color gradient: blue (top) → red (bottom) — Ejen Ali's costume colours
echo ""
echo -e "  \033[1;38;5;27m██╗██████╗ ██╗███████╗${NC}"
echo -e "  \033[1;38;5;57m██║██╔══██╗██║██╔════╝${NC}"
echo -e "  \033[1;38;5;93m██║██████╔╝██║███████╗${NC}"
echo -e "  \033[1;38;5;129m██║██╔══██╗██║╚════██║${NC}"
echo -e "  \033[1;38;5;161m██║██║  ██║██║███████║${NC}"
echo -e "  \033[1;38;5;196m╚═╝╚═╝  ╚═╝╚═╝╚══════╝${NC}"
echo -e "${DIM}  Dev Workflow Suite for AI Coding Tools${NC}"
echo ""

# ── Tool selection ────────────────────────────────────────────────────────────
SELECTED_TOOLS=()

if [ -n "$TOOL_OVERRIDE" ]; then
  # --tool= flag: skip menu, use override directly
  SELECTED_TOOLS=("$TOOL_OVERRIDE")
elif [ ! -t 0 ] || [ ! -t 1 ]; then
  # Non-interactive (piped): use all detected tools, or fallback
  for t in "${ALL_TOOLS[@]}"; do
    if is_detected "$t"; then SELECTED_TOOLS+=("$t"); fi
  done
  [ ${#SELECTED_TOOLS[@]} -eq 0 ] && SELECTED_TOOLS=("fallback")
else
  # Interactive: show checkbox menu
  show_menu
fi

TOOLS_LABEL=$(IFS=', '; echo "${SELECTED_TOOLS[*]}")
if [ -n "$TOOL_OVERRIDE" ]; then
  echo -e "  ${BOLD}Tool:${NC}   $TOOLS_LABEL (--tool override)"
else
  echo -e "  ${BOLD}Tools:${NC}  $TOOLS_LABEL"
fi
if [ "$GLOBAL" = "1" ]; then
  echo -e "  ${BOLD}Scope:${NC}  global (per-tool dirs)"
else
  echo -e "  ${BOLD}Target:${NC} $TARGET"
fi
echo -e "  ${BOLD}Mode:${NC}   $( [ "$FORCE" = "1" ] && echo "overwrite (--force)" || echo "skip existing (--force to overwrite)" )"
echo ""

if ! command -v curl &>/dev/null; then
  echo -e "${RED}Error: curl is required${NC}" >&2
  exit 1
fi

# ── Version check ─────────────────────────────────────────────────────────────
REMOTE_VERSION=$(curl -sSfL "$GITHUB_RAW/VERSION" 2>/dev/null | tr -d '[:space:]')
REMOTE_VERSION="${REMOTE_VERSION:-unknown}"

if [ "$GLOBAL" = "1" ]; then
  VERSION_FILE="$HOME/.ai/iris-version"
else
  VERSION_FILE="$TARGET/.iris-ai/version"
fi

if [ -f "$VERSION_FILE" ]; then
  LOCAL_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')
  if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
    echo -e "  ${DIM}Version: $LOCAL_VERSION (up to date)${NC}"
  else
    echo -e "  ${YELLOW}Update available: $LOCAL_VERSION → $REMOTE_VERSION${NC}"
  fi
else
  echo -e "  ${DIM}Version: $REMOTE_VERSION (fresh install)${NC}"
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

# ── Install files per selected tool ──────────────────────────────────────────
for tool in "${SELECTED_TOOLS[@]}"; do
  tool_paths "$tool" "$GLOBAL"

  if [ "$GLOBAL" = "1" ]; then
    case "$tool" in
      opencode) display_root="~/.config/opencode/" ;;
      fallback) display_root="~/.ai/" ;;
      *)        display_root="~/.$tool/" ;;
    esac
  else
    case "$tool" in
      fallback) display_root="$TARGET/.ai/" ;;
      *)        display_root="$TARGET/.$tool/" ;;
    esac
  fi

  echo -e "${YELLOW}$tool${NC} → $display_root"

  echo -e "  ${DIM}Skills${NC}   → $TOOL_SKILLS_DIR"
  for file in "${SKILL_FILES[@]}"; do
    subdir="$(echo "$file" | cut -d'/' -f2)"
    fetch_file "$file" "$TOOL_SKILLS_DIR/$subdir/SKILL.md"
  done

  echo -e "  ${DIM}Agents${NC}   → $TOOL_AGENTS_DIR"
  for file in "${AGENT_FILES[@]}"; do
    filename="${file##*/}"
    fetch_file "$file" "$TOOL_AGENTS_DIR/$filename"
  done

  echo -e "  ${DIM}Commands${NC} → $TOOL_COMMANDS_DIR"
  for file in "${COMMAND_FILES[@]}"; do
    filename="${file##*/}"
    fetch_file "$file" "$TOOL_COMMANDS_DIR/$filename"
  done

  echo ""
done

# ── Project-level files (always in the project, never global) ─────────────────
if [ "$GLOBAL" = "0" ]; then
  mkdir -p "$TARGET/docs/iris-ai/briefs"
  mkdir -p "$TARGET/docs/iris-ai/specs"
  mkdir -p "$TARGET/docs/iris-ai/plans"
  mkdir -p "$TARGET/docs/iris-ai/docs"
  mkdir -p "$TARGET/docs/iris-ai/debriefs"

  echo -e "${YELLOW}Project files${NC} → $TARGET/.iris-ai"
  fetch_file "AGENTS.md" "$TARGET/.iris-ai/AGENTS.md"
  fetch_file "CLAUDE.md" "$TARGET/.iris-ai/CLAUDE.md"
  echo -e "  ${CYAN}create${NC}   $TARGET/docs/iris-ai/{briefs,specs,plans,docs,debriefs}"
  echo ""
fi

# ── Write version file ────────────────────────────────────────────────────────
if [ "$REMOTE_VERSION" != "unknown" ]; then
  mkdir -p "$(dirname "$VERSION_FILE")"
  echo "$REMOTE_VERSION" > "$VERSION_FILE"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo -e "${GREEN}${BOLD}Done.${NC} $INSTALLED installed, $SKIPPED skipped."
echo ""
TOOLS_DONE=$(IFS=', '; echo "${SELECTED_TOOLS[*]}")
echo -e "  ${DIM}Version:       $REMOTE_VERSION${NC}"
echo -e "  ${DIM}Installed for: $TOOLS_DONE${NC}"
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
