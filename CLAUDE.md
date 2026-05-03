# CLAUDE.md — IRIS

IRIS is a dev workflow command suite for Claude Code. It guides any development task from idea to implementation — clarifying requirements, writing specs, planning tasks, executing with TDD, and wrapping up with docs.

---

## 1. Command Routing

Any message starting with `/iris` is handled by `.claude/commands/iris.md`.

Usage:
- `/iris <idea or task>` — starts from the beginning (brief stage)
- `/iris spec` — jump to spec stage (brief must exist)
- `/iris plan` — jump to plan stage (spec must exist)
- `/iris ops` — jump to ops stage (plan must be confirmed)
- `/iris debrief` — jump to debrief stage

---

## 2. Execution Pipeline

```
1. Load .claude/commands/iris.md
2. Load agents/iris-agent.md
3. Load the relevant iris-* skill
4. Execute the stage
5. Save output to docs/iris-ai/{type}/YYYY-MM-DD-{slug}-{stage}.md
6. Chain to next stage automatically (unless awaiting user input)
```

---

## 3. Output Structure

| Stage | File | Folder |
|---|---|---|
| Brief | `{slug}-brief.md` | `docs/iris-ai/briefs/` |
| Spec | `{slug}-spec.md` | `docs/iris-ai/specs/` |
| Plan | `{slug}-plan.md` | `docs/iris-ai/plans/` |
| Implementation notes | `{slug}-ops.md` | `docs/iris-ai/docs/` |
| Debrief | `{slug}-debrief.md` | `docs/iris-ai/debriefs/` |

---

## 4. Core Principles

- **No gaps before spec.** Never write a spec until all clarifying questions are answered.
- **No execution before plan approval.** Always pause and get explicit confirmation before `iris-ops`.
- **TDD always.** Write the test first. Make it pass. Refactor. All tests must be green before moving to the next task.
- **Bite-sized tasks.** Each task in the plan is 2–5 minutes of work.
- **Between-task review.** After each task: code review against spec, check tests pass, report issues before moving on.
- **Subagents for execution.** Each ops task may be dispatched as a subagent with full spec + plan context.

---

## 5. Output Style

- Markdown always — headings, bullets, tables, code blocks
- No preamble ("Great!", "Certainly!") — start with the answer
- Be specific — "use PostgreSQL" not "use a database"
- Suggest options with tradeoffs when multiple valid approaches exist
