---
name: iris-ops
description: Use when executing an approved implementation plan task by task — following TDD or Verify mode, dispatching subagents, running tests, and reviewing code between tasks. Also use when asked to implement, build, code, execute the plan, or start development on a confirmed spec and plan.
---

# iris-ops

## Overview
Execute the approved plan strictly and methodically. Two execution modes are supported — chosen once at the start of ops and applied consistently to every task. Full test suite between tasks. Code review between tasks. No skipping, no shortcuts.

| Mode | Order | When to use |
|---|---|---|
| **TDD** | Test (RED) → Implement (GREEN) → Refactor | Interface is uncertain or the task is exploratory |
| **Verify** | Implement → Test against spec → Green → Refactor | Spec is tight and you know exactly what you're writing |

## Process

### 1. Load context
- Read confirmed master plan from `docs/iris-ai/plans/*-plan.md`
- Identify the first group with status `pending` in the master plan's Groups table
- Read that group's file from `docs/iris-ai/plans/` (e.g., `*-plan-g1.md`)
- Read confirmed spec from `docs/iris-ai/specs/*-spec.md`
- Read confirmed brief from `docs/iris-ai/briefs/*-brief.md`

### 2. Create a feature branch (git flow)
Before writing any code, set up the correct branch following git flow:

1. Check the current branch with `git branch --show-current`
2. If already on a `feature/*` branch, ask: "You're on `{branch}`. Continue here, or create a new feature branch?"
3. Otherwise:
   - Identify the base branch — prefer `develop` if it exists, fall back to `main`/`master`
   - Switch to the base branch and pull latest: `git checkout develop && git pull`
   - Create the feature branch using the branch name from the group file: `git checkout -b feature/{group-slug}`
4. Confirm the new branch before proceeding

**Git flow branch rules:**
| Branch | Purpose |
|---|---|
| `main` / `master` | Production-ready code only — never commit features directly |
| `develop` | Integration branch — all features merge here first |
| `feature/{group-slug}` | One branch per group, always branched off `develop` |

Never implement directly on `main`, `master`, or `develop`. If the user insists, warn them and ask for explicit confirmation before complying.

### 3. Choose execution mode

Ask the user once before the first task:

```
Which execution mode?

  1. TDD — write the failing test first, then implement (classic red-green-refactor)
  2. Verify — implement first, then write tests against the spec until green

Both modes require all tests to pass before moving to the next task.
```

Store the chosen mode and apply it to every task in this ops session. Do not ask again per task.

### 4. Identify current task
- Identify the current task (first incomplete task in the active group file)
- When `Subagent: yes` on a task, read the `Agent` field from the task definition
- If `Agent` is `audit` or `probe`, load `agents/{name}-agent.md` as the agent context for that subagent dispatch
- If `Agent` is blank or `iris`, IRIS handles the task itself

### 5. For each task — execution cycle

#### TDD mode

**Step 1 — Write the test (RED)**
Write the test defined in the plan for this task. Run it. Confirm it fails. If it doesn't fail, the test is wrong — fix it before proceeding.

**Step 2 — Implement (GREEN)**
Write the minimum code to make the test pass. No more than what's needed.

**Step 3 — Refactor**
Clean up the implementation if needed. Run tests again. Still green.

---

#### Verify mode

**Step 1 — Implement**
Write the full implementation for this task as defined in the plan.

**Step 2 — Write tests against the spec**
Write tests that verify the spec requirement this task covers. Reference the spec — not the code you just wrote. The test must be an independent verifier of the requirement, not a mirror of the implementation.

**Step 3 — Run until green**
Run the tests. Fix the implementation (or the test if it's wrong) until all pass.

**Step 4 — Refactor**
Clean up the implementation if needed. Run tests again. Still green.

---

#### Both modes — subagent dispatch

If this task is flagged for subagent dispatch:
- Dispatch a subagent with:
  - Full spec doc
  - Full plan doc
  - This specific task definition
  - The active execution mode (TDD or Verify)
  - Agent context: `agents/{name}-agent.md` (loaded from the `Agent` field)
  - Instruction to follow the agent's own process and return when done
- Wait for subagent result
- Verify the agent's output and tests before accepting

#### Both modes — full test suite

After every task (regardless of mode): run ALL tests, not just the new ones. Every test must pass before moving on. If any test fails — stop, fix, re-run. Do not proceed with a red suite.

**Step N — Track deviations**
If this task's implementation differed structurally from the spec or plan, add it to the deviation list (kept in memory until the end-of-group sync):
- API shape changed
- Data model field added or removed
- Requirement dropped or added
- New dependency introduced

Cosmetic or naming differences are not deviations — do not track them.

### 6. Between-task review

After every task, before starting the next:

**Code review checklist:**
- Does the implementation match the spec requirement it covers?
- Does it match what the plan task defined?
- Are there any code quality issues (naming, structure, duplication)?
- Are there security concerns?
- Are there performance concerns?

**Report format:**
```
Task {N} complete.
Tests: all green ({X} passing)
Code review:
- vs spec: pass / [issue]
- vs plan: pass / [issue]
- Quality: pass / [issue]
Issues found: none / [list with severity]
```

If issues are found: fix them before moving to the next task.

Update the task report with the commit line before closing out the task:
```
Commit: {type}({scope}): {subject} [{short-sha}]
```

### 7. Commit the task

After the between-task review passes, commit all staged changes for this task:

- Follow `../references/commit-guidelines.md` for message format and type selection
- One commit per task — do not batch multiple tasks into one commit
- If the working tree is clean (no file changes), skip the commit and note it in the task report

### 8. End-of-group sequence

When all tasks in the active group file are complete, before starting any new group:

**1. Sync docs**
Apply all tracked structural deviations to the spec and plan files:
- Update the affected section in the spec (`*-spec.md`)
- Update the affected task description in the group plan file
- Report what changed

Append a deviation log to `docs/iris-ai/docs/YYYY-MM-DD-{slug}-ops.md`:

```
## Group {N} Deviation Log
- [deviation description] — [what was updated in docs]
```

If no deviations were tracked: log "No structural deviations — docs unchanged."

**2. Update group status**
- In the master plan file: set this group's Status column from `pending` → `done`
- In the group file: update the `**Status:**` header to `done`

**3. Hard pause — post-group summary and menu**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Group {N} complete: {Group Name}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tasks:  {X}/{X} done
Tests:  all green
Branch: feature/{group-slug}
Docs:   {list changes, or "no changes"}

What would you like to do next?

  1. Finish branch — merge feature/{group-slug} → develop (or main)
  2. Create PR — open a pull request for this group
  3. Do nothing — I'll handle the branch manually
  4. Custom — tell me what to do

Next up: Group {N+1}: {Name} ({X} tasks) — feature/{next-group-slug}
(replace "Next up" line with "All groups complete." if this was the last group)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Wait for user response.** After options 1 or 2 complete, wait — do not auto-start the next group. The next group starts only when the user explicitly says so ("continue", "start group 2", etc.).

### 9. Progress tracking
After each task report, show: `Group {G} — Progress: {N}/{total} tasks complete`

Announce the next task before starting it.

### 10. Save implementation notes
Append each task's output to: `docs/iris-ai/docs/YYYY-MM-DD-{slug}-ops.md`

After the first task's output is appended (file created), output a clickable link:
> Ops log: [docs/iris-ai/docs/YYYY-MM-DD-{slug}-ops.md](docs/iris-ai/docs/YYYY-MM-DD-{slug}-ops.md)

### 11. Chain to iris-debrief
When all groups show status `done` in the master plan: show "All groups complete. All tests green." — invoke the `iris-debrief` skill automatically.

## Rules
- Always create a `feature/{group-slug}` branch per group before writing any code — never implement on `main`, `master`, or `develop`
- Ask for execution mode once at the start — apply it consistently to every task, never mix mid-session
- In Verify mode, write tests against the spec requirement — never against the implementation
- Never move to the next task with a failing test
- Never skip the between-task code review
- Subagents receive the full spec + plan context — never a partial brief
- If a task reveals a flaw in the plan, stop and surface it to the user before continuing
- Never auto-start the next group — always hard-pause after the end-of-group sequence and wait for explicit user trigger
- Commit after every task once the between-task review passes — follow `../references/commit-guidelines.md`; never batch multiple tasks into one commit
