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

| Agent | Role | Slash command |
|---|---|---|
| **IRIS** | Orchestrator — runs the full brief → spec → plan → ops → debrief pipeline | `/iris <idea>` |
| **Ali** | Implementation — coding, feature work, TDD discipline | `/ali` |
| **Alicia** | Testing & review — writes tests, reviews code after each task | `/alicia` |
| **Bakar** | DevOps & tooling — CI/CD, infra, scripts, environment setup | `/bakar` |
| **Rizwan** | Security & architecture — auth, data handling, APIs, system design audits | `/rizwan` |
| **General Rama** | Strategic oversight — reviews plans and direction at a high level | `/rama` |
| **Comot** | Debugging — investigates broken behaviour, reports findings only | `/comot` |

IRIS auto-dispatches Ali, Alicia, Bakar, Rizwan, and Comot during ops based on the `Agent` field in each plan task. General Rama is manual-only — invoke him directly for a strategic read on a plan or architecture.

---

## Agent files

All agent definitions live in `agents/`. Each file contains the agent's persona, specialty, and process. IRIS loads the relevant agent file as subagent context when dispatching.

---

## Output files

Every mission generates structured docs under `.iris-ai/outputs/` — always in the project folder, never global:

| Stage | File | Folder |
|---|---|---|
| Brief | `{slug}-brief.md` | `.iris-ai/outputs/briefs/` |
| Spec | `{slug}-spec.md` | `.iris-ai/outputs/briefs/` |
| Plan | `{slug}-plan.md` | `.iris-ai/outputs/tasks/` |
| Implementation notes | `{slug}-ops.md` | `.iris-ai/outputs/docs/` |
| Debrief | `{slug}-debrief.md` | `.iris-ai/outputs/docs/` |
