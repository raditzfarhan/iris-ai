---
name: iris-plan
description: Use when breaking a confirmed spec into a sequenced, bite-sized implementation plan with TDD tasks — each 2–5 minutes of work. Also use when asked to plan implementation, create a task list, sequence development work, or prepare a sprint plan before coding begins.
---

# iris-plan

## Overview
Convert the confirmed spec into a precise, sequenced task list grouped by feature area. Every task is atomic (2–5 min), has a test to write first, and assigns an Agent from the dispatch table. Output is a master plan index plus one file per group. Self-review the plan before presenting it.

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

### 3. Group tasks by feature area

Cluster all generated tasks into feature groups before self-review:

1. **Identify groups** — cluster tasks by the feature or area they build (e.g., Blog Feature, Settings, Auth). If tasks span multiple groups (e.g., a shared DB migration or base model all features depend on), create a **Foundation** group that runs first, or attach them to the earliest group that needs them. Note cross-group dependencies in Sequencing Notes.
2. **Assign branch names** — each group gets `feature/{group-slug}`
3. **Present to user for confirmation:**
   ```
   Proposed groups:
     Group 1: Blog Feature (8 tasks) — feature/blog-feature
     Group 2: Settings (5 tasks) — feature/settings

   Does this grouping look right? You can rename groups, merge them, or split before I save.
   ```
4. **Wait for user approval.** Apply any requested changes before proceeding to self-review.

### 4. Self-review pass
Before showing the plan to the user, review it against these checks:

| Check | Question |
|---|---|
| Contradictions | Does any task conflict with another? |
| Gaps | Is anything from the spec not covered by a task? |
| Loopholes | Are there edge cases in the spec with no corresponding task? |
| Feasibility | Can these tasks actually be done in this sequence? |
| Best practices | Does the plan follow conventions from the available skills? |
| TDD coverage | Does every functional requirement have a test task? |
| Group independence | Are all groups truly independent of each other? |
| Cross-group dependency | Does any task in group N depend on work from a later group? If so, move it to the earlier group or note it in Sequencing Notes. |
| Branch isolation | Can each group's branch be created and merged independently? |

Document findings. Refine the plan. If gaps are found, add tasks. If contradictions are found, resolve them.

### 5. Present refined plan
Show:
1. Self-review summary (what was found, what was changed)
2. Full task list

End with: "Plan ready. Confirm to begin implementation."

**Do not proceed until the user explicitly confirms.**

### 6. Save the plan

Save all files to `.iris-ai/outputs/tasks/`:

**Master file** — `YYYY-MM-DD-{slug}-plan.md`

Include:
- `# Plan: {Feature Name}` heading
- `**Spec:**` link to the brief spec file
- `**Date:**` YYYY-MM-DD
- `## Groups` section with a table: `# | Group | Branch | Status | File` — one row per group, Status starts as `pending`, File is the per-group filename
- `## Sequencing Notes` section — cross-group dependencies or "None."

**Per-group files** — `YYYY-MM-DD-{slug}-plan-g{N}.md` (one per group)

Include:
- `# Group {N}: {Group Name}` heading
- `**Branch:** feature/{group-slug}`
- `**Status:** pending`
- `**Parent plan:** YYYY-MM-DD-{slug}-plan.md`
- `## Tasks` section with all tasks for this group in the standard task format:
  - `**What:**`, `**Test first:**`, `**Agent:**`, `**Subagent:**`, `**Est:**`

### 7. Wait for confirmation
Only after user confirms: "Plan confirmed. Starting implementation." — invoke `.claude/skills/iris-ops/SKILL.md`.

## Rules
- Never start ops without explicit user confirmation
- Every task is 2–5 minutes — if a task is larger, split it
- Self-review is mandatory, not optional
- TDD: every functional requirement needs at least one test task before its implementation task
