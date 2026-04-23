---
name: iris-ops
description: Use when executing an approved implementation plan task by task — following TDD, dispatching subagents, running tests, and reviewing code between tasks. Also use when asked to implement, build, code, execute the plan, or start development on a confirmed spec and plan.
---

# iris-ops

## Overview
Execute the approved plan strictly and methodically. TDD on every task. Full test suite between tasks. Code review between tasks. No skipping, no shortcuts.

## Process

### 1. Load context
- Read confirmed plan from `.iris-ai/outputs/tasks/*-plan.md`
- Read confirmed spec from `.iris-ai/outputs/briefs/*-spec.md`
- Read confirmed brief from `.iris-ai/outputs/briefs/*-brief.md`
- Identify the current task (first incomplete task in the plan)

### 2. For each task — TDD cycle

**Step 1 — Write the test (RED)**
Write the test defined in the plan for this task. Run it. Confirm it fails. If it doesn't fail, the test is wrong — fix it before proceeding.

**Step 2 — Implement (GREEN)**
Write the minimum code to make the test pass. No more than what's needed.

If this task is flagged for subagent dispatch:
- Dispatch a subagent with:
  - Full spec doc
  - Full plan doc
  - This specific task definition
  - Instruction to follow TDD and return when tests are green
- Wait for subagent result
- Verify tests are green before accepting

**Step 3 — Refactor**
Clean up the implementation if needed. Run tests again. Still green.

**Step 4 — Run full test suite**
Run ALL tests, not just the new one. Every test must pass before moving on. If any test fails — stop, fix, re-run. Do not proceed with a red suite.

### 3. Between-task review

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

### 4. Progress tracking
After each task report, show: `Progress: {N}/{total} tasks complete`

Announce the next task before starting it.

### 5. Save implementation notes
Append each task's output to: `.iris-ai/outputs/docs/YYYY-MM-DD-{slug}-ops.md`

### 6. Chain to iris-debrief
When all tasks are complete: "All tasks done. All tests green." — invoke `skills/iris-debrief/SKILL.md` automatically.

## Rules
- TDD is non-negotiable — write the test first, always
- Never move to the next task with a failing test
- Never skip the between-task code review
- Subagents receive the full spec + plan context — never a partial brief
- If a task reveals a flaw in the plan, stop and surface it to the user before continuing
