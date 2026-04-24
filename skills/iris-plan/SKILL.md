---
name: iris-plan
description: Use when breaking a confirmed spec into a sequenced, bite-sized implementation plan with TDD tasks — each 2–5 minutes of work. Also use when asked to plan implementation, create a task list, sequence development work, or prepare a sprint plan before coding begins.
---

# iris-plan

## Overview
Convert the confirmed spec into a precise, sequenced task list. Every task is atomic (2–5 min), has a test to write first, and assigns an Agent from the dispatch table. Self-review the plan before presenting it.

## Process

### 1. Load context
- Read confirmed spec from `.iris-ai/outputs/briefs/*-spec.md`
- Read confirmed brief from `.iris-ai/outputs/briefs/*-brief.md`

### 2. Generate task list
Break implementation into atomic tasks following this discipline:

**Each task must:**
- Be completable in 2–5 minutes
- Have one clear, verifiable outcome
- Include the test to write first (TDD — red before green)
- Assign `Agent` field using the dispatch table: `iris` (all implementation, testing, infra, and review — default), `audit` (security or architecture deep dive), `probe` (investigating unknown breakage)
- Flag if it should be dispatched as a subagent (yes/no)

**Sequencing rules:**
- Infrastructure and schema tasks first
- Tests before implementation in each unit
- No task depends on work from a later task
- Group related tasks in phases (setup → core → edge cases → polish)

### 3. Self-review pass
Before showing the plan to the user, review it against these checks:

| Check | Question |
|---|---|
| Contradictions | Does any task conflict with another? |
| Gaps | Is anything from the spec not covered by a task? |
| Loopholes | Are there edge cases in the spec with no corresponding task? |
| Feasibility | Can these tasks actually be done in this sequence? |
| Best practices | Does the plan follow conventions from the available skills? |
| TDD coverage | Does every functional requirement have a test task? |

Document findings. Refine the plan. If gaps are found, add tasks. If contradictions are found, resolve them.

### 4. Present refined plan
Show:
1. Self-review summary (what was found, what was changed)
2. Full task list

End with: "Plan ready. Confirm to begin implementation."

**Do not proceed until the user explicitly confirms.**

### 5. Save the plan
Save to: `.iris-ai/outputs/tasks/YYYY-MM-DD-{slug}-plan.md`

### 6. Wait for confirmation
Only after user confirms: "Plan confirmed. Starting implementation." — invoke `.claude/skills/iris-ops/SKILL.md`.

## Rules
- Never start ops without explicit user confirmation
- Every task is 2–5 minutes — if a task is larger, split it
- Self-review is mandatory, not optional
- TDD: every functional requirement needs at least one test task before its implementation task
