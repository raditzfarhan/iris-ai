# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.0] — 2026-05-05

### Added

**Core workflow**
- 5-stage IRIS pipeline: brief → spec → plan → ops → debrief
- Ejen Ali theme — command names and agent roles mirror the animated series
- Agent roster: IRIS (orchestrator), Probe (debugger), Audit (security/architecture), Strategy (direction review)
- Slash commands: `/iris`, `/probe`, `/audit`, `/strategy`

**iris-brief**
- Relentless gap-closing — keeps questioning until zero ambiguities remain
- Every clarifying question includes pros/cons and a grounded recommendation per option

**iris-spec**
- Surfaces 2–3 implementation options with explicit tradeoffs before writing anything
- Clickable saved-file links after every save
- Spec docs saved to dedicated `docs/iris-ai/specs/` folder

**iris-plan**
- Task grouping step — breaks plan into logical groups before sequencing
- Group coherence checks in the mandatory self-review pass
- Saves master plan + one file per group

**iris-ops**
- Group-based execution with branch naming per group
- Deviation tracking throughout the TDD cycle
- End-of-group sequence: doc sync, status update, hard pause menu
- Progress tracking and automatic debrief trigger on completion

**Installer**
- Multi-tool support: Claude Code, Cursor, Windsurf, Opencode, fallback (`.ai/`)
- Interactive `tput` checkbox menu with TTY detection — detected tools pre-selected
- Per-tool directory resolution via `tool_paths()`
- `--tool=<name>` flag to skip the menu
- `--force` flag to overwrite existing files
- `--global` flag to install to home directories instead of the project
- Version check — compares local vs remote, shows update available message

**Output structure**
- All generated docs under `docs/iris-ai/` in the target project
- Separate folders per stage: `briefs/`, `specs/`, `plans/`, `docs/`, `debriefs/`

### Changed

- IRIS promoted to super-agent — handles all implementation, testing, code review, and infra directly; specialist agents dispatched only for targeted work
- Installer restructured: `commands/` moved to repo root alongside `skills/` and `agents/`
- Output path changed from `.iris-ai/outputs/` to `docs/iris-ai/`
- Plan output folder renamed from `tasks/` to `plans/`
- Debrief docs moved from `docs/` to dedicated `debriefs/` folder
- `docs/iris-ai/docs/` designated as catch-all for any other generated docs

[1.0.0]: https://github.com/raditzfarhan/iris-ai/releases/tag/v1.0.0
