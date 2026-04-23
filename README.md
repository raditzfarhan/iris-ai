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
Execute task by task. IRIS reads the `Agent` field and dispatches:

| Agent | Dispatched for | What they do |
|---|---|---|
| Ali | Coding / implementation | Write test → implement → refactor → run suite |
| Alicia | Tests / code review | Review vs spec, plan, quality, surface-level security |
| Bakar | Infra / tooling / CI | Scaffold config, scripts, pipelines |
| Rizwan | Security / architecture | Full audit — auth, data, dependencies, structure |
| Comot | Debugging | Investigate broken behaviour, report findings only |

Full test suite after every task. Code review after every task. If a task reveals a plan flaw, stop and surface it before continuing.

### Debrief — `/iris debrief`
Document what was built, decisions made, deviations from plan, test coverage, open items, and next steps. List all generated docs. Offer `.docx` export.

---

## Installation

**From GitHub (recommended):**

```bash
# First install
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- .

# Upgrade — overwrite existing files
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- . --force
```

**From a local clone:**

```bash
bash /path/to/iris-ai/install.sh /path/to/your-project

# Upgrade
bash /path/to/iris-ai/install.sh /path/to/your-project --force
```

The installer skips files that already exist by default — pass `--force` to overwrite. It copies commands, skills, and agents into `.claude/`, `skills/`, and `agents/`, and creates the `.iris-ai/outputs/` folder structure for generated docs. Nothing else is carried over.

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

IRIS dispatches specialized agents during `iris-ops` based on task type. Each is also directly invokable via slash command at any time.

| Agent | Slash command | Specialty | Dispatched for |
|---|---|---|---|
| Ali | `/ali` | Implementation | Coding, feature work, spikes |
| Alicia | `/alicia` | Testing & review | Test writing, between-task code review |
| Bakar | `/bakar` | DevOps & tooling | CI/CD, infra, environment setup |
| Rizwan | `/rizwan` | Security & architecture | Auth, APIs, data handling, system design |
| General Rama | `/rama` | Strategic oversight | Manual only — direction and plan review |
| Comot | `/comot` | Debugging | Investigating broken behaviour |

IRIS reads the `Agent` field in each plan task and loads the corresponding agent file as subagent context. General Rama is never auto-dispatched — invoke him directly when you want a strategic read on a plan or architecture.

---

## File Structure

```
iris-ai/                          ← this repo
├── .claude/
│   └── commands/
│       ├── iris.md               ← /iris command router
│       ├── ali.md                ← /ali
│       ├── alicia.md             ← /alicia
│       ├── bakar.md              ← /bakar
│       ├── rizwan.md             ← /rizwan
│       ├── rama.md               ← /rama
│       └── comot.md              ← /comot
├── agents/
│   ├── iris-agent.md             ← orchestrator
│   ├── ali-agent.md              ← implementation
│   ├── alicia-agent.md           ← testing & review
│   ├── bakar-agent.md            ← devops & tooling
│   ├── rizwan-agent.md           ← security & architecture
│   ├── rama-agent.md             ← strategic oversight
│   └── comot-agent.md            ← debugging
├── skills/
│   ├── iris-brief/SKILL.md       ← clarify until zero gaps
│   ├── iris-spec/SKILL.md        ← spec + project context scan + impl options
│   ├── iris-plan/SKILL.md        ← bite-sized tasks + self-review + confirm gate
│   ├── iris-ops/SKILL.md         ← TDD + agent dispatch + between-task review
│   └── iris-debrief/SKILL.md     ← wrap up + doc export offer
├── docs/
│   └── project.md
├── install.sh
└── CLAUDE.md

your-project/                     ← after install
├── .iris-ai/
│   └── outputs/
│       ├── briefs/               ← brief and spec docs
│       ├── tasks/                ← plan docs
│       └── docs/                 ← ops notes and debrief docs
├── .claude/commands/             ← iris + all 6 character commands
├── agents/                       ← iris-agent + all 6 character agents
└── skills/iris-*/SKILL.md
```
