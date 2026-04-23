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

| Stage | Command | What happens |
|---|---|---|
| Brief | `/iris <idea>` | Clarify requirements until zero gaps |
| Spec | `/iris spec` | Write a complete technical specification |
| Plan | `/iris plan` | Break work into 2–5 min atomic tasks with self-review |
| Ops | `/iris ops` | Execute with TDD, subagents, and between-task review |
| Debrief | `/iris debrief` | Wrap up: decisions, open items, next steps |

IRIS chains stages automatically, pausing only when it needs your input — at three points: clarification answers, implementation option selection, and plan confirmation.

### Brief
Ask targeted clarifying questions — in one message, not one-by-one — until there are zero gaps, ambiguities, or assumptions. Confirms understanding before writing anything.

### Spec
Reads the existing codebase, scans available skills and agents, writes numbered testable requirements, data model, API contracts, edge cases, and surfaces 2–3 implementation options with tradeoffs. User picks direction before the plan is written.

### Plan
Breaks the spec into atomic 2–5 minute tasks, each with a test to write first. Runs a mandatory self-review pass before presenting — checking for contradictions, gaps, loopholes, feasibility, and TDD coverage. Requires explicit confirmation before ops begins.

### Ops
Executes task by task: write test (RED) → implement (GREEN) → refactor → run full suite. Between every task: code review against spec and plan. If a task reveals a plan flaw, stops and surfaces it before continuing.

### Debrief
Documents what was built, decisions made, deviations from plan, test coverage, open items, and next steps. Lists all generated docs and offers `.docx` export.

---

## Installation

**From GitHub (recommended):**

```bash
curl -sSL https://raw.githubusercontent.com/raditzfarhan/iris-ai/main/install.sh | bash -s -- .
```

**From a local clone:**

```bash
bash /path/to/iris-ai/install.sh /path/to/your-project

# Or from inside the target project:
bash /path/to/iris-ai/install.sh .
```

The installer detects which mode to use automatically. It copies the command, skills, and agent into `.claude/`, `skills/`, and `agents/`, and creates the `.iris-ai/outputs/` folder structure for generated docs. Nothing else is carried over.

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
│       └── iris.md               ← /iris command router
├── agents/
│   └── iris-agent.md             ← IRIS agent (role, personality, output structures)
├── skills/
│   ├── iris-brief/SKILL.md       ← clarify until zero gaps
│   ├── iris-spec/SKILL.md        ← spec + project context scan + impl options
│   ├── iris-plan/SKILL.md        ← bite-sized tasks + self-review + confirm gate
│   ├── iris-ops/SKILL.md         ← TDD + subagent dispatch + between-task review
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
├── .claude/commands/iris.md
├── agents/iris-agent.md
└── skills/iris-*/SKILL.md
```
