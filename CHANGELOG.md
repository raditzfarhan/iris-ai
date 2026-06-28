# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.2.1] — 2026-06-28

### Added

- **`skills/references/iris-voice.md`** — canonical voice guide for IRIS: character statement, stage registers (brief → spec → plan → ops → debrief), voice rules, forbidden phrases table, before/after rewrite examples, and two Ejen Ali catchphrases with placement guidance ("Tiada misi yang terlalu kecil." at brief open; "Bertindak Segera!" at ops kickoff)
- **Voice layer in all 6 skill files** — each skill now has a `## Voice` section defining its stage register and linking to the voice guide; targeted language changes bring IRIS's personality into the workflow itself without touching process logic or output structures:
  - `iris-brief` — opens with "Tiada misi yang terlalu kecil."; confirmation step uses warmer, more direct phrasing
  - `iris-spec` — recommendation framing is direct ("Option A. Here's why.") not hedged; closing ask tightened
  - `iris-spec-review` — findings stated as facts; issues-found close is direct ("Fix them and I'll re-run.")
  - `iris-plan` — self-review reported as a record, not an apology; confirmation gate has a briefing-room feel
  - `iris-ops` — opens with "Bertindak Segera!" before first task; tightened between-task report format; task announcement and problem flag formats specified
  - `iris-debrief` — merge offer and doc export close use mission-completion framing

### Changed

- `agents/iris-agent.md` Personality section replaced — expanded from a single-line constraint ("Direct. Precise. No filler.") to a full character block with stage energy, friction handling, pronoun guidance, forbidden phrases, and a reference to the voice guide

---

## [1.2.0] — 2026-06-26

### Added

- **`skills/references/commit-guidelines.md`** — shared commit reference file covering the frequency rule (commit at logical checkpoints, not at task-group boundaries), the classic 50/72 formatting rule, the full Conventional Commits specification with a canonical type table and breaking-change syntax, and a reusable commit message template with three worked examples
- **Commit step in `iris-ops`** — new Step 7 "Commit the task" fires after the between-task review passes and before the next task begins; enforces one commit per task, references `commit-guidelines.md` for format, and appends a `Commit: {type}({scope}): {subject} [{short-sha}]` line to the task report; steps 7–10 renumbered to 8–11
- **Commit hygiene checkpoint in `iris-debrief`** — Step 4 now runs a pre-merge hygiene check: lists all commits on the feature branch via `git log --oneline develop..HEAD`, validates each subject against Conventional Commits format, and surfaces non-conforming commits before asking whether to proceed with the merge

### Changed

- `iris-ops` Rules section now explicitly requires a commit after every task once the between-task review passes — batching multiple tasks into one commit is disallowed
- Installer (`install.sh`) adds a `REFERENCE_FILES` array and install loop so that `skills/references/` files are copied to the target tool's skills directory alongside the per-stage `SKILL.md` files

### Fixed

- `iris-ops` Step 11 chain reference replaced `.claude/skills/iris-debrief/SKILL.md` (Claude-specific path) with the platform-neutral `iris-debrief` skill name

---

## [1.1.1] — 2026-06-24

### Fixed

- Installer (`install.sh`) now includes `skills/iris-spec-review/SKILL.md` in `SKILL_FILES` — it was missing from the file list, so fresh installs would not receive the spec review skill
- Installer usage block updated to show `/iris spec-review` alongside the other stage commands

---

## [1.1.0] — 2026-06-24

### Added

- **`iris-spec-review`** — new quality-gate stage that runs automatically after `iris-spec` saves the spec, before handing off to `iris-plan`
  - Checks four dimensions: completeness (no TBD/placeholders), requirement alignment (spec matches brief, no scope creep), buildability (every FR is actionable without ambiguity), and contradictions (no conflicting requirements or NFRs)
  - Calibrated to flag only issues that will cause real problems during implementation — not style, not theory
  - Outputs a `PASSED` summary or a `NEEDS REVISION` findings table with a clear "why it blocks implementation" column
  - Loops until clean, then chains to `iris-plan` automatically
- `/iris spec-review` — direct command to re-run the spec quality gate at any point

### Changed

- `iris-spec` now chains to `iris-spec-review` automatically after saving (previously chained directly to `iris-plan`)
- `iris-plan` self-review pass adds three new checks: **DRY** (no duplicated patterns), **KISS** (simplest solution), **YAGNI** (every task traces to a spec requirement)
- `iris-plan` rules section now enforces DRY, KISS, and YAGNI explicitly
- README updated to reflect the 6-stage workflow diagram, new stage description, updated usage commands, core principles, and file structure

---

## [1.0.5] — 2026-05-06

### Added

- MIT license (`LICENSE.md`)
- License badge in README

### Changed

- `iris-spec` codebase exploration overhauled — now actively searches for existing functions, services, models, and patterns related to the feature before recommending any approach; defaults to reuse and extension over creating new code
- Implementation options in `iris-spec` now include what each option reuses vs builds fresh
- Spec output includes a **Codebase Context** section; data model and API contracts mark each item as existing / extended / new

---

## [1.0.4] — 2026-05-06

### Added

- **Verify mode** in `iris-ops` — implement first, then write tests against the spec (not the code) until green; complements classic TDD for cases where the spec is tight and the implementation is already clear
- Mode selection prompt at the start of every ops session — choose TDD or Verify once, applied consistently to every task
- Subagent dispatch now passes the active execution mode so subagents honour the same choice

---

## [1.0.3] — 2026-05-05

### Changed

- `sync-version.yml` renamed to `Release` workflow — now creates a GitHub Release automatically on every tag push, with release notes extracted from the matching `## [x.y.z]` section in `CHANGELOG.md`

---

## [1.0.2] — 2026-05-05

### Fixed

- `sync-version.yml` tag pattern changed from `v*` to `[0-9]*` to match the project's tag convention (e.g. `1.0.2` not `v1.0.2`) — the action was not triggering because no tags carried the `v` prefix
- Removed the `#v` strip from `GITHUB_REF_NAME` since the prefix is not used

---

## [1.0.1] — 2026-05-05

### Added

- `/iris version` — shows the installed IRIS version by reading `.iris-ai/version`; prints a helpful message if the file is missing
- GitHub Actions workflow (`sync-version.yml`) — automatically writes `VERSION` from the tag name on every `v*` tag push, keeping the file in sync without manual edits

### Changed

- README version badge switched from static (`shields.io/badge`) to dynamic (`shields.io/github/v/release`) — updates automatically on each GitHub release

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

[1.2.1]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.2.1
[1.2.0]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.2.0
[1.1.1]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.1.1
[1.1.0]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.1.0
[1.0.5]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.0.5
[1.0.4]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.0.4
[1.0.3]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.0.3
[1.0.2]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.0.2
[1.0.1]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.0.1
[1.0.0]: https://github.com/raditzfarhan/iris-ai/releases/tag/1.0.0
