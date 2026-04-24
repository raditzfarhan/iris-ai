# IRIS

A dev workflow command suite for Claude Code. IRIS guides any development task from raw idea to working, tested, reviewed implementation — one disciplined stage at a time.

Named after **IRIS**, the AI companion in the Malaysian animated series *Ejen Ali* who helps the protagonist execute missions. You bring the idea. IRIS walks you through the full mission.

| Series Element | IRIS Equivalent |
|---|---|
| IRIS (AI companion) | Claude — guides the user through the mission |
| Ali (the agent) | The developer — brings the idea, makes decisions |
| MATA (the agency) | The project codebase and tooling |
| Mission | The development task |

---

## The 5-Stage Workflow

```
/iris <idea>
      │
      ▼
  [ BRIEF ] ── auto ──▶ [ SPEC ] ── user picks option ──▶ [ PLAN ] ── user confirms ──▶ [ OPS ] ── auto ──▶ [ DEBRIEF ]
```

IRIS chains automatically, pausing only at three points: clarification answers, implementation option selection, and plan confirmation.

---

### Brief — `/iris <idea>`
Ask clarifying questions one at a time, each with labelled options (a, b, c…) plus a free-text escape. Wait for the answer before asking the next question. Keep asking until every gap and edge case is resolved. Confirm understanding in plain language. No spec until the brief is confirmed.

### Spec — `/iris spec`
Read the codebase. Scan available skills and agents. Write numbered testable requirements, data model, API contracts, and edge cases. Surface 2–3 implementation options with explicit tradeoffs. User picks direction before the plan is written.

### Plan — `/iris plan`
Break the spec into atomic 2–5 minute tasks. Every task has a test to write first and an Agent assigned from the dispatch table. Run a mandatory self-review pass — check for contradictions, gaps, loopholes, and feasibility. Present refined plan. Require explicit confirmation before ops begins.

### Ops — `/iris ops`
Execute task by task with full TDD discipline. IRIS handles all implementation, testing, code review, and infra directly. For tasks that need specialist focus, IRIS dispatches:

| Agent | Dispatched for | What they do |
|---|---|---|
| probe | Unknown breakage during implementation | Trace from symptom to root cause, report findings only |
| audit | Security or architecture deep dives | Full checklist — auth, data, dependencies, structure |

Full test suite after every task. Code review after every task. If a task reveals a plan flaw, stop and surface it before continuing.

### Debrief — `/iris debrief`
Document what was built, decisions made, deviations from plan, test coverage, open items, and next steps. List all generated docs. Offer `.docx` export.

---

## Installation

```bash
# Project install (auto-detects your AI tool)
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- .

# Global install
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- . --global

# Update — overwrite existing files
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- . --force

# Force a specific tool
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- . --tool=cursor
```

The installer detects **all** AI coding tools present in the project and installs to each. Existing files are skipped by default — pass `--force` to overwrite (use this when updating IRIS).

**What goes where:**

| What | Project install | Global install (`--global`) |
|---|---|---|
| Skills | `skills/` (project root) | `~/.ai/skills/` |
| Agents | `agents/` (project root) | `~/.ai/agents/` |
| Commands (Claude) | `.claude/commands/` | `~/.claude/commands/` |
| Project docs | `.iris-ai/outputs/` | never global |

Skills and agents live at the project root and are shared across all tools. Slash commands are installed separately for each detected tool that supports them (currently Claude Code only).

Generated docs (`.iris-ai/outputs/`), `AGENTS.md`, and `CLAUDE.md` always install into the project folder — never globally.

---

## Usage

Once installed, open Claude Code in the target project and run:

```
/iris <describe what you want to build>
```

Jump to a specific stage directly:

```
/iris spec      ← requires a confirmed brief in .iris-ai/outputs/briefs/
/iris plan      ← requires a confirmed spec
/iris ops       ← requires an approved plan
/iris debrief   ← wraps up a completed implementation
```

---

## Output Files

Every mission generates structured docs under `.iris-ai/outputs/` in the target project:

| Stage | File | Folder |
|---|---|---|
| Brief | `{slug}-brief.md` | `.iris-ai/outputs/briefs/` |
| Spec | `{slug}-spec.md` | `.iris-ai/outputs/briefs/` |
| Plan | `{slug}-plan.md` | `.iris-ai/outputs/tasks/` |
| Implementation notes | `{slug}-ops.md` | `.iris-ai/outputs/docs/` |
| Debrief | `{slug}-debrief.md` | `.iris-ai/outputs/docs/` |

---

## Core Principles

| Principle | Rule |
|---|---|
| No gaps before spec | Brief must be confirmed before spec is written |
| No execution before approval | Plan must be explicitly confirmed before ops starts |
| TDD always | Write the failing test first. Every time. No exceptions. |
| Bite-sized tasks | 2–5 minutes each. If larger, split it. |
| Self-reviewing plan | Plan checks itself for contradictions, gaps, and feasibility before you see it |
| Between-task review | Code review after every task. Fix issues before next task. |
| Subagents for execution | Tasks can be dispatched as subagents with full spec + plan context |
| Project-aware spec | Spec scans existing skills and agents — uses what's already there |

---

## Agents

IRIS is the primary agent — it handles all implementation, testing, code review, and infra directly. Three specialist agents are available for targeted work, each also invokable via slash command at any time.

| Agent | Slash command | Role | Auto-dispatched? |
|---|---|---|---|
| **IRIS** | `/iris` | Orchestrator + implementation engine | Always |
| **Probe** | `/probe` | Debugging investigator — traces breakage to root cause, reports only | When root cause is unknown |
| **Audit** | `/audit` | Security & architecture auditor — full checklist, every finding listed | For security/architecture tasks |
| **Strategy** | `/strategy` | Strategic direction reviewer — proceed / reconsider / stop verdict | Manual only |

---

## File Structure

```
iris-ai/                          ← this repo
├── .claude/
│   └── commands/
│       ├── iris.md               ← /iris command router
│       ├── probe.md              ← /probe
│       ├── audit.md              ← /audit
│       └── strategy.md           ← /strategy
├── agents/
│   ├── iris-agent.md             ← orchestrator + implementation engine
│   ├── probe-agent.md            ← debugging investigator
│   ├── audit-agent.md            ← security & architecture auditor
│   └── strategy-agent.md         ← strategic direction reviewer
├── skills/
│   ├── iris-brief/SKILL.md       ← clarify until zero gaps
│   ├── iris-spec/SKILL.md        ← spec + project context scan + impl options
│   ├── iris-plan/SKILL.md        ← bite-sized tasks + self-review + confirm gate
│   ├── iris-ops/SKILL.md         ← TDD + agent dispatch + between-task review
│   └── iris-debrief/SKILL.md     ← wrap up + doc export offer
├── docs/
│   └── project.md
├── install.sh
├── AGENTS.md                     ← agent index for AI tools
└── CLAUDE.md

your-project/                     ← after project install
├── .iris-ai/
│   ├── AGENTS.md                 ← IRIS agent index (isolated, safe from project files)
│   ├── CLAUDE.md                 ← IRIS instructions (Claude reads this automatically)
│   └── outputs/
│       ├── briefs/               ← brief and spec docs
│       ├── tasks/                ← plan docs
│       └── docs/                 ← ops notes and debrief docs
├── .claude/commands/             ← iris + all 6 character commands (Claude only)
├── skills/iris-*/                ← skills (shared across all detected tools)
└── agents/                       ← agents (shared across all detected tools)
```
