# Design: IRIS Single Branch Per Plan & Blocker Protocol

**Date:** 2026-08-17
**Project:** iris-ai
**Status:** Approved
**Supersedes (partial):** `docs/superpowers/specs/2026-04-30-iris-task-groups-design.md` — branching section only. Group clustering, per-group task files, deviation tracking, and doc sync from that design are unchanged.

---

## Overview

Three changes to `iris-plan` and `iris-ops`:

1. **One feature branch per plan, not per group.** All groups generated from the same `/iris` prompt now share a single `feature/{slug}` branch instead of each group getting its own `feature/{group-slug}` branch.
2. **Conditional per-plan subfolder.** Plans that split into 2+ groups save their master + group files under `docs/iris-ai/plans/{slug}/`; single-group plans stay flat, as today.
3. **Blocker Protocol for `iris-ops`.** When execution hits something that blocks a task, IRIS must stop and ask the user rather than improvising a workaround.

---

## Motivation

- The task-groups design (2026-04-30) gave every group its own branch. In practice, groups from the same prompt are pieces of one feature, not independent efforts — splitting them across branches fragments a single unit of work and complicates the eventual merge back to `develop`.
- Group and plan files for a multi-group plan currently sit flat in `docs/iris-ai/plans/` next to every other plan's files, making it harder to see which files belong together.
- Without an explicit blocker protocol, execution could silently work around plan/spec gaps with fixes that don't fit the intended design, discovered only after the fact.

---

## Change 1: Single Branch Per Plan

### Branching model

- `iris-plan`'s master file gets one `**Branch:** feature/{slug}` header (the same `{slug}` used for the brief/spec/plan filenames). The Groups table drops its `Branch` column — groups no longer carry their own branch name.
- `iris-ops` creates `feature/{slug}` once, before Group 1 starts, using the existing base-branch logic (prefer `develop`, fall back to `main`/`master`; if already on a `feature/*` branch, ask before creating a new one). All groups in the plan commit to this one branch.
- **Resumed plans:** the branch-creation step only runs when starting Group 1. When `iris-ops` loads a plan and the first pending group is Group 2 or later (a resumed/continued plan), it checks the current branch first — if already on `feature/{slug}`, proceed without creating or asking; only fall back to the base-branch-and-create flow if not on that branch (e.g. the user switched away between sessions).

### Every per-group branch reference to remove or rewrite

The 2026-04-30 design and its current implementation encode a branch name at the group level in at least seven places via direct text edits, listed below — plus the end-of-group hard-pause menu templates, which embed further `feature/{group-slug}` references and are rewritten in full in the next section ("End-of-group pause / menu"). Between this table and that section, every occurrence in both skill files is accounted for:

| # | Location | Current (per-group) | New (per-plan) |
|---|---|---|---|
| 1 | `iris-plan/SKILL.md` — Groups table in master file template | `Branch` column, one row per group | Column removed; single `**Branch:** feature/{slug}` header above the table instead |
| 2 | `iris-plan/SKILL.md` — per-group file template | `**Branch:** feature/{group-slug}` header field | Header field removed from the per-group template entirely (branch now lives only on the master file) |
| 3 | `iris-plan/SKILL.md` — grouping process step ("Assign branch names — each group gets `feature/{group-slug}`") | Per-group branch assignment step | Step removed; replaced with a single "Assign the plan's branch name — `feature/{slug}`" step that runs once, not per group |
| 4 | `iris-plan/SKILL.md` — group-confirmation example shown to the user | Shows `feature/blog-feature`, `feature/settings` per group | Example updated to show one shared branch, e.g. `Branch: feature/blog-and-settings` printed once above the group list, not per group |
| 5 | `iris-ops/SKILL.md` — git flow branch rules table row | `feature/{group-slug}` \| "One branch per group, always branched off develop" | `feature/{slug}` \| "One branch per plan, always branched off develop" |
| 6 | `iris-ops/SKILL.md` — Rules section bullet ("Always create a `feature/{group-slug}` branch per group before writing any code") | Per-group branch-creation rule | "Always create a `feature/{slug}` branch once per plan before writing any code" |
| 7 | `iris-ops/SKILL.md` — branch-creation process step ("Create the feature branch using the branch name from the group file: `git checkout -b feature/{group-slug}`") | Reads the branch name from the (now-deleted, per issue 2 above) per-group file field | "Create the feature branch once, before Group 1, using the plan's branch name from the master file: `git checkout -b feature/{slug}`" — this step no longer runs on every group, only when the first pending group is Group 1 (see "Resumed plans" above for Group 2+ behavior) |

The "What Does NOT Change" section's claim that "git flow rules... unchanged" refers only to the branch *hierarchy and purposes* (`main`/`develop`/`feature/*` roles) — the `feature/*` row's granularity (group → plan) is explicitly in scope and changes per rows 5-7 above.

### End-of-group pause / menu

- The hard pause after each group still happens — doc sync, status update, summary — it's a useful checkpoint independent of branching.
- **Mid-plan groups** (not the last one) get a simplified menu, replacing the current 4-option template for these cases:

  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Group {N} complete: {Group Name}
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Tasks:  {X}/{X} done
  Tests:  all green
  Branch: feature/{slug} (in progress — {N}/{total groups} groups done)
  Docs:   {list changes, or "no changes"}

  1. Continue to next group
  2. Pause here — I'll continue later

  Next up: Group {N+1}: {Name} ({X} tasks)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ```

- **Only after the last group** does the existing full menu appear, with its branch references updated from `feature/{group-slug}` to `feature/{slug}` throughout (the `Branch:` line and option 1's "Finish branch — merge feature/{slug} → develop"), and its "Next up" line replaced with "All groups complete.":

  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Group {N} complete: {Group Name}
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Tasks:  {X}/{X} done
  Tests:  all green
  Branch: feature/{slug}
  Docs:   {list changes, or "no changes"}

  What would you like to do next?

    1. Finish branch — merge feature/{slug} → develop (or main)
    2. Create PR — open a pull request for this plan
    3. Do nothing — I'll handle the branch manually
    4. Custom — tell me what to do

  All groups complete.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ```

### Self-review checklist changes

- Keep "Group independence" and "Cross-group dependency" checks in `iris-plan` — still meaningful for sequencing and review checkpoints.
- Drop "Branch isolation" ("can each group's branch be created and merged independently?") — no longer applicable with a single shared branch.

---

## Change 2: Conditional Per-Plan Subfolder

- **1 group** (no real grouping needed): save flat, as today — `docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan.md`, no group suffix, no subfolder. (The `YYYY-MM-DD-` date prefix from the current filename convention is retained everywhere below — omitted from the tree names for readability only.)
- **2+ groups**: save under `docs/iris-ai/plans/{slug}/`, containing:
  - `YYYY-MM-DD-{slug}-plan.md` — master index
  - `YYYY-MM-DD-{slug}-plan-g1.md`, `YYYY-MM-DD-{slug}-plan-g2.md`, … — one per group

  Note the subfolder itself is named `{slug}` only (no date prefix) — the date lives on the filenames inside it.
- `iris-ops` checks for the subfolder first when loading a plan, falling back to the flat file if no subfolder exists.

---

## Change 3: Blocker Protocol (`iris-ops` only)

Applies only to `iris-ops`, since blockers surface during execution. `iris-brief`, `iris-spec`, and `iris-plan` already pause for user input at their own checkpoints and are unchanged.

Replaces the existing rule *"If a task reveals a flaw in the plan, stop and surface it to the user before continuing"* with a fuller protocol:

> Triggered whenever execution hits something that blocks the current task — a plan/spec assumption that doesn't hold, a missing dependency, an approach that doesn't work as designed, etc.
>
> 1. **Stop immediately.** Do not invent an unplanned workaround, hack, or fallback to push through.
> 2. **Report:** what was found, and why it blocks the current task/plan.
> 3. **Suggest 2–3 ways to proceed**, with trade-offs.
> 4. **Ask the user** to pick one — or propose their own solution.
> 5. If the user proposes their own solution, **review it for feasibility** and flag concerns before implementing.

The Rules section is updated to: *"If execution hits a blocker, follow the Blocker Protocol — never patch around it silently."*

### Reconciling with the existing Voice section

`iris-ops`'s Voice section currently defines a "Problem flag format" — `"Task N hit a wall — [what happened]. [what I'm doing to fix it]."` — and a rule that "when a problem surfaces, name it immediately and state what's being done." Both phrasings assume the problem gets fixed autonomously and reported after the fact, which conflicts with the Blocker Protocol's stop-and-ask requirement. Both are updated:

- **Problem flag format** becomes: `"Task N hit a wall — [what happened]. Here's how I see we could proceed: [1-2 line summary of the options]."` — reporting the blocker and its options, not a fix already in motion.
- The Rules bullet "When a problem surfaces, name it immediately and state what's being done" becomes "When a blocker surfaces, name it immediately and follow the Blocker Protocol — state the options, not a fix already in motion."

This keeps the existing terse, immediate-disclosure voice intact — only the assumption that the problem is already being autonomously resolved is removed.

---

## What Does NOT Change

- Group clustering logic and user confirmation of proposed groups (`iris-plan`)
- Per-group task file format, deviation tracking, and end-of-group doc sync (`iris-ops`)
- The TDD cycle per task
- `iris-brief`, `iris-spec`, `iris-debrief` — unchanged
- Git flow rules (`main`/`master` production-only, `develop` integration branch) — unchanged, only the feature-branch granularity changes

---

## Out of Scope

- Concurrent group execution / worktree automation
- Automatic PR creation without user confirmation
- Applying the Blocker Protocol to skills other than `iris-ops`
