# AGENTS

This project uses **IRIS** — a dev workflow agent suite for AI coding tools. IRIS guides any development task from raw idea to working, tested, reviewed implementation through a disciplined 5-stage pipeline.

---

## Workflow

```
/iris <idea>
      │
      ▼
  [ BRIEF ] ── auto ──▶ [ SPEC ] ── user picks option ──▶ [ PLAN ] ── user confirms ──▶ [ OPS ] ── auto ──▶ [ DEBRIEF ]
```

---

## Available Agents

| Agent | Role | Slash command | Auto-dispatched? |
|---|---|---|---|
| **IRIS** | Orchestrator and implementation engine — runs the full pipeline, handles all coding, testing, code review, and infra | `/iris <idea>` | Always |
| **Probe** | Debugging investigator — traces broken behaviour from symptom to root cause, reports findings only, never fixes | `/probe` | When root cause is unknown |
| **Audit** | Security & architecture auditor — full checklist, every finding listed with severity and required fix | `/audit` | For security/architecture tasks |
| **Strategy** | Strategic direction reviewer — assesses whether a plan solves the right problem, delivers proceed/reconsider/stop verdict | `/strategy` | Manual only |

---

## Agent files

All agent definitions live in `agents/`. Each file contains the agent's role, process, and output format. IRIS loads the relevant agent file as subagent context when dispatching.

---

## Output files

Every mission generates structured docs under `docs/iris-ai/` — always in the project folder, never global:

| Stage | File | Folder |
|---|---|---|
| Brief | `{slug}-brief.md` | `docs/iris-ai/briefs/` |
| Spec | `{slug}-spec.md` | `docs/iris-ai/specs/` |
| Plan | `{slug}-plan.md` | `docs/iris-ai/tasks/` |
| Implementation notes | `{slug}-ops.md` | `docs/iris-ai/docs/` |
| Debrief | `{slug}-debrief.md` | `docs/iris-ai/docs/` |
