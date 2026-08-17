# IRIS Branch-Per-Plan & Blocker Protocol Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update `iris-plan` and `iris-ops` so a whole plan shares one `feature/{slug}` branch instead of one branch per group, multi-group plans nest their files under a per-plan subfolder, and `iris-ops` follows an explicit stop-and-ask Blocker Protocol instead of improvising workarounds when execution hits something that blocks it.

**Architecture:** Two skill files modified — `skills/iris-plan/SKILL.md` (grouping step, self-review table, save step) and `skills/iris-ops/SKILL.md` (load-context step, branch-creation step, Voice section, new Blocker Protocol section, Rules section). No new files created. All changes are surgical text edits to existing markdown, verified by reading the file back — there is no test runner for skill-instruction files.

**Tech Stack:** Markdown skill files only.

**Spec:** `docs/superpowers/specs/2026-08-17-iris-branch-per-plan-and-blocker-protocol-design.md`

**Branch:** `feature/iris-branch-per-plan-and-blocker-protocol` (one branch for this whole plan)

---

## File Map

**Modify:**
- `skills/iris-plan/SKILL.md` — single plan-level branch assignment, drop "Branch isolation" self-review check, rewrite save step for conditional per-plan subfolder (1 group = flat file, 2+ groups = subfolder)
- `skills/iris-ops/SKILL.md` — conditional subfolder-aware load, branch creation once per plan (with resumed-plan detection), git-flow table row, new Blocker Protocol section, Voice "Problem flag format" reconciliation, Rules section updates

---

## Group 1: iris-plan changes

### Task 1: Single plan-level branch name in the grouping step

**Files:**
- Modify: `skills/iris-plan/SKILL.md:39-53`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-plan/SKILL.md`. Confirm the numbered list under `### 3. Group tasks by feature area` currently has item 2 as `**Assign branch names** — each group gets `feature/{group-slug}`` and the confirmation example shows a branch per group.

- [ ] **Step 2: Replace the numbered list and example**

Find:
```
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
```

Replace with:
```
1. **Identify groups** — cluster tasks by the feature or area they build (e.g., Blog Feature, Settings, Auth). If tasks span multiple groups (e.g., a shared DB migration or base model all features depend on), create a **Foundation** group that runs first, or attach them to the earliest group that needs them. Note cross-group dependencies in Sequencing Notes.
2. **Assign the plan's branch name** — one `feature/{slug}` branch for the whole plan, shared by every group in it (not one per group)
3. **Present to user for confirmation:**
   ```
   Proposed groups (branch: feature/blog-and-settings):
     Group 1: Blog Feature (8 tasks)
     Group 2: Settings (5 tasks)

   Does this grouping look right? You can rename groups, merge them, or split before I save.
   ```
4. **Wait for user approval.** Apply any requested changes before proceeding to self-review.
```

- [ ] **Step 3: Verify**

Read `skills/iris-plan/SKILL.md`. Confirm item 2 now reads "Assign the plan's branch name" (singular, per-plan) and the example shows one branch listed once, not per group.

- [ ] **Step 4: Commit**

```bash
git add skills/iris-plan/SKILL.md
git commit -m "feat(iris-plan): assign one branch per plan instead of per group"
```

---

### Task 2: Drop the "Branch isolation" self-review check

**Files:**
- Modify: `skills/iris-plan/SKILL.md:68`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-plan/SKILL.md`. Confirm the self-review table (Step 4) has a row: `| Branch isolation | Can each group's branch be created and merged independently? |`.

- [ ] **Step 2: Remove the row**

Find:
```
| Cross-group dependency | Does any task in group N depend on work from a later group? If so, move it to the earlier group or note it in Sequencing Notes. |
| Branch isolation | Can each group's branch be created and merged independently? |
| DRY | Does any task duplicate logic or patterns already in the codebase or in an earlier task? If so, extend what exists. |
```

Replace with:
```
| Cross-group dependency | Does any task in group N depend on work from a later group? If so, move it to the earlier group or note it in Sequencing Notes. |
| DRY | Does any task duplicate logic or patterns already in the codebase or in an earlier task? If so, extend what exists. |
```

- [ ] **Step 3: Verify**

Read `skills/iris-plan/SKILL.md`. Confirm the self-review table no longer has a "Branch isolation" row and has 11 rows total (down from 12).

- [ ] **Step 4: Commit**

```bash
git add skills/iris-plan/SKILL.md
git commit -m "feat(iris-plan): drop branch isolation self-review check"
```

---

### Task 3: Rewrite the save step for conditional per-plan subfolder

**Files:**
- Modify: `skills/iris-plan/SKILL.md:84-109`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-plan/SKILL.md`. Confirm `### 6. Save the plan` currently always saves a master file plus one per-group file (no 1-group-vs-2+-group distinction), the Groups table description includes a `Branch` column, and the per-group file template includes a `**Branch:** feature/{group-slug}` line.

- [ ] **Step 2: Replace the save step body**

Find:
```
### 6. Save the plan

Save all files to `docs/iris-ai/plans/`:

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
  - `**What:**`, `**Test first:**`, `**Agent:**`, `**Subagent:**`, `**Est:**`, `**Status:** pending`

After saving, output clickable links:
> Saved: [docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan.md](docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan.md)
> Per-group files: [g1](docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan-g1.md), [g2](docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan-g2.md) … (one link per group)
```

Replace with:
```
### 6. Save the plan

**If the plan has only 1 group** — no real grouping needed. Save a single flat file, same as a non-grouped plan, to `docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan.md`.

Include:
- `# Plan: {Feature Name}` heading
- `**Spec:**` link to the brief spec file
- `**Branch:** feature/{slug}`
- `**Date:**` YYYY-MM-DD
- `## Tasks` section with all tasks in the standard task format: `**What:**`, `**Test first:**`, `**Agent:**`, `**Subagent:**`, `**Est:**`, `**Status:** pending`
- `## Sequencing Notes` section — or "None."

After saving, output a clickable link:
> Saved: [docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan.md](docs/iris-ai/plans/YYYY-MM-DD-{slug}-plan.md)

**If the plan has 2+ groups** — save under a per-plan subfolder: `docs/iris-ai/plans/{slug}/`.

**Master file** — `docs/iris-ai/plans/{slug}/YYYY-MM-DD-{slug}-plan.md`

Include:
- `# Plan: {Feature Name}` heading
- `**Spec:**` link to the brief spec file
- `**Branch:** feature/{slug}`
- `**Date:**` YYYY-MM-DD
- `## Groups` section with a table: `# | Group | Status | File` — one row per group, Status starts as `pending`, File is the per-group filename
- `## Sequencing Notes` section — cross-group dependencies or "None."

**Per-group files** — `docs/iris-ai/plans/{slug}/YYYY-MM-DD-{slug}-plan-g{N}.md` (one per group)

Include:
- `# Group {N}: {Group Name}` heading
- `**Status:** pending`
- `**Parent plan:** YYYY-MM-DD-{slug}-plan.md`
- `## Tasks` section with all tasks for this group in the standard task format:
  - `**What:**`, `**Test first:**`, `**Agent:**`, `**Subagent:**`, `**Est:**`, `**Status:** pending`

After saving, output clickable links:
> Saved: [docs/iris-ai/plans/{slug}/YYYY-MM-DD-{slug}-plan.md](docs/iris-ai/plans/{slug}/YYYY-MM-DD-{slug}-plan.md)
> Per-group files: [g1](docs/iris-ai/plans/{slug}/YYYY-MM-DD-{slug}-plan-g1.md), [g2](docs/iris-ai/plans/{slug}/YYYY-MM-DD-{slug}-plan-g2.md) … (one link per group)
```

- [ ] **Step 3: Verify**

Read `skills/iris-plan/SKILL.md`. Confirm:
- Step 6 now branches explicitly on group count (1 vs 2+)
- The 1-group case has no `Branch` column, no per-group file, and includes a `**Branch:** feature/{slug}` line directly in the flat file
- The 2+-group case's master file has a `## Groups` table with columns `# | Group | Status | File` (no `Branch` column) and a `**Branch:** feature/{slug}` line above it
- The 2+-group case's per-group file template no longer has a `**Branch:**` line
- Both cases' save paths and output links are consistent with each other (flat file vs `{slug}/` subfolder)

- [ ] **Step 4: Commit**

```bash
git add skills/iris-plan/SKILL.md
git commit -m "feat(iris-plan): conditional per-plan subfolder and single branch in save step"
```

---

## Group 2: iris-ops changes

### Task 4: Conditional subfolder-aware load context

**Files:**
- Modify: `skills/iris-ops/SKILL.md:30-35`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-ops/SKILL.md`. Confirm `### 1. Load context` currently always reads `docs/iris-ai/plans/*-plan.md` flat and always expects a per-group file.

- [ ] **Step 2: Replace Step 1 body**

Find:
```
### 1. Load context
- Read confirmed master plan from `docs/iris-ai/plans/*-plan.md`
- Identify the first group with status `pending` in the master plan's Groups table
- Read that group's file from `docs/iris-ai/plans/` (e.g., `*-plan-g1.md`)
- Read confirmed spec from `docs/iris-ai/specs/*-spec.md`
- Read confirmed brief from `docs/iris-ai/briefs/*-brief.md`
```

Replace with:
```
### 1. Load context
- Look for a per-plan subfolder first: `docs/iris-ai/plans/{slug}/`. If it exists, read the master plan from `docs/iris-ai/plans/{slug}/*-plan.md`; otherwise read the flat file `docs/iris-ai/plans/*-plan.md` directly (single-group plan, no subfolder)
- If a subfolder exists: identify the first group with status `pending` in the master plan's Groups table, and read that group's file from the same subfolder (e.g., `*-plan-g1.md`)
- If there's no subfolder (flat file): treat the whole file as the only unit of work — there is no separate group file to load
- Read confirmed spec from `docs/iris-ai/specs/*-spec.md`
- Read confirmed brief from `docs/iris-ai/briefs/*-brief.md`
```

- [ ] **Step 3: Verify**

Read `skills/iris-ops/SKILL.md`. Confirm Step 1 checks for the subfolder before deciding how to load the plan, and covers both the subfolder and flat-file cases explicitly.

- [ ] **Step 4: Commit**

```bash
git add skills/iris-ops/SKILL.md
git commit -m "feat(iris-ops): load plan from per-plan subfolder or flat file"
```

---

### Task 5: Branch creation once per plan, with resumed-plan detection

**Files:**
- Modify: `skills/iris-ops/SKILL.md:37-55`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-ops/SKILL.md`. Confirm `### 2. Create a feature branch (git flow)` currently creates a branch unconditionally using the group file's branch name, and the git flow rules table has a `feature/{group-slug}` row.

- [ ] **Step 2: Replace Step 2 body**

Find:
```
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
```

Replace with:
```
### 2. Create a feature branch (git flow)
Before writing any code, set up the correct branch following git flow. This only runs once per plan — when starting Group 1 (or the plan's only unit of work, if it has no groups). It does not repeat when moving on to Group 2, 3, etc.

**Starting Group 1 (or a single-group plan):**
1. Check the current branch with `git branch --show-current`
2. If already on a `feature/*` branch, ask: "You're on `{branch}`. Continue here, or create a new feature branch?"
3. Otherwise:
   - Identify the base branch — prefer `develop` if it exists, fall back to `main`/`master`
   - Switch to the base branch and pull latest: `git checkout develop && git pull`
   - Create the feature branch using the plan's branch name from the master file: `git checkout -b feature/{slug}`
4. Confirm the new branch before proceeding

**Resuming at Group 2 or later** (the first pending group identified in Step 1 is not Group 1 — a continued session): skip branch creation entirely and check the current branch instead:
- If already on `feature/{slug}`, proceed without asking.
- If not, warn the user they're not on the plan's branch and ask whether to switch to it or continue where they are.

**Git flow branch rules:**
| Branch | Purpose |
|---|---|
| `main` / `master` | Production-ready code only — never commit features directly |
| `develop` | Integration branch — all features merge here first |
| `feature/{slug}` | One branch per plan, shared by every group in it, always branched off `develop` |

Never implement directly on `main`, `master`, or `develop`. If the user insists, warn them and ask for explicit confirmation before complying.
```

- [ ] **Step 3: Verify**

Read `skills/iris-ops/SKILL.md`. Confirm Step 2 distinguishes "starting Group 1" (creates the branch) from "resuming at Group 2+" (checks, doesn't create), and the git flow rules table row now reads `feature/{slug}` | "One branch per plan, shared by every group in it, always branched off `develop`".

- [ ] **Step 4: Commit**

```bash
git add skills/iris-ops/SKILL.md
git commit -m "feat(iris-ops): create feature branch once per plan, not per group"
```

---

### Task 6: Add Blocker Protocol section and reconcile Voice problem-flag format

**Files:**
- Modify: `skills/iris-ops/SKILL.md:19` (Voice section)
- Modify: `skills/iris-ops/SKILL.md:231-234` (insert new section between Process and Rules)

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-ops/SKILL.md`. Confirm the Voice section's "Problem flag format" line reads `"Task N hit a wall — [what happened]. [what I'm doing to fix it]."`, and confirm `### 11. Chain to iris-debrief` is immediately followed by `## Rules` with no section in between.

- [ ] **Step 2: Update the Voice section's problem flag format**

Find:
```
Problem flag format: "Task N hit a wall — [what happened]. [what I'm doing to fix it]."
```

Replace with:
```
Problem flag format: "Task N hit a wall — [what happened]. Here's how I see we could proceed: [1-2 line summary of the options]."
```

- [ ] **Step 3: Insert the Blocker Protocol section**

Find:
```
### 11. Chain to iris-debrief
When all groups show status `done` in the master plan: show "All groups complete. All tests green." — invoke the `iris-debrief` skill automatically.

## Rules
```

Replace with:
```
### 11. Chain to iris-debrief
When all groups show status `done` in the master plan: show "All groups complete. All tests green." — invoke the `iris-debrief` skill automatically.

## Blocker Protocol

Triggered whenever execution hits something that blocks the current task — a plan/spec assumption that doesn't hold, a missing dependency, an approach that doesn't work as designed, etc.

1. **Stop immediately.** Do not invent an unplanned workaround, hack, or fallback to push through.
2. **Report:** what was found, and why it blocks the current task/plan.
3. **Suggest 2–3 ways to proceed**, with trade-offs.
4. **Ask the user** to pick one — or propose their own solution.
5. If the user proposes their own solution, **review it for feasibility** and flag concerns before implementing.

## Rules
```

- [ ] **Step 4: Verify**

Read `skills/iris-ops/SKILL.md`. Confirm the Voice section's problem flag format states options rather than a fix in motion, and a new `## Blocker Protocol` section with all 5 numbered steps sits between `### 11. Chain to iris-debrief` and `## Rules`.

- [ ] **Step 5: Commit**

```bash
git add skills/iris-ops/SKILL.md
git commit -m "feat(iris-ops): add Blocker Protocol and reconcile voice with it"
```

---

### Task 7: Update Rules section for per-plan branching and the Blocker Protocol

**Files:**
- Modify: `skills/iris-ops/SKILL.md:235,241,247`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-ops/SKILL.md`. Confirm the Rules section has these three bullets (in this order): the `feature/{group-slug}` branch bullet, "If a task reveals a flaw in the plan, stop and surface it to the user before continuing", and "When a problem surfaces, name it immediately and state what's being done — never bury it at the end of a report".

- [ ] **Step 2: Update the branch-creation rule**

Find:
```
- Always create a `feature/{group-slug}` branch per group before writing any code — never implement on `main`, `master`, or `develop`
```

Replace with:
```
- Always create a `feature/{slug}` branch once per plan before writing any code — never implement on `main`, `master`, or `develop`
```

- [ ] **Step 3: Replace the "flaw in the plan" rule with a Blocker Protocol reference**

Find:
```
- If a task reveals a flaw in the plan, stop and surface it to the user before continuing
```

Replace with:
```
- If execution hits a blocker, follow the Blocker Protocol — never patch around it silently
```

- [ ] **Step 4: Update the "problem surfaces" rule**

Find:
```
- When a problem surfaces, name it immediately and state what's being done — never bury it at the end of a report
```

Replace with:
```
- When a blocker surfaces, name it immediately and follow the Blocker Protocol — state the options, not a fix already in motion
```

- [ ] **Step 5: Verify**

Read `skills/iris-ops/SKILL.md`. Confirm all three Rules bullets are updated as above, the Rules section still has the same total bullet count as before (no bullets accidentally dropped or duplicated), and no remaining occurrence of `{group-slug}` exists anywhere in the file — search the full file for `group-slug` and confirm zero matches.

- [ ] **Step 6: Commit**

```bash
git add skills/iris-ops/SKILL.md
git commit -m "feat(iris-ops): update rules for per-plan branch and blocker protocol"
```

---

### Task 8: Full cross-file verification

**Files:**
- Read only: `skills/iris-plan/SKILL.md`, `skills/iris-ops/SKILL.md`

- [ ] **Step 1: Search both files for stale references**

Search `skills/iris-plan/SKILL.md` and `skills/iris-ops/SKILL.md` for the literal string `group-slug`. Expected: zero matches in either file.

- [ ] **Step 2: Search for stale "one branch per group" language**

Search both files for the phrase `per group` immediately following the word `branch`, and for `feature/{group`. Expected: zero matches — every remaining `branch` reference should describe a single branch shared by the whole plan.

- [ ] **Step 3: Confirm the design's 7-row reference table is fully covered**

Cross-check each of the 7 rows in the design doc's "Every per-group branch reference to remove or rewrite" table (`docs/superpowers/specs/2026-08-17-iris-branch-per-plan-and-blocker-protocol-design.md`) against the current file contents. Confirm each row's "New (per-plan)" text is present verbatim (or equivalent) in the corresponding file.

- [ ] **Step 4: Confirm the end-of-group menu templates match the design**

Read `skills/iris-ops/SKILL.md` Step 8 ("End-of-group sequence"). Note: this task plan did not include a task to rewrite the hard-pause menu templates themselves (mid-plan simplified menu vs. full end-of-plan menu) — flag this as a gap if the menu templates still show `feature/{group-slug}` in the `Branch:` line, option 1, or the "Next up" line. If found, this is expected — proceed to Task 9 to fix it.

No commit for this task — it's a verification-only checkpoint.

---

### Task 9: Rewrite the end-of-group hard-pause menu templates

**Files:**
- Modify: `skills/iris-ops/SKILL.md:195-218`

- [ ] **Step 1: Read the file to confirm current state**

Read `skills/iris-ops/SKILL.md`. Confirm `### 8. End-of-group sequence`, part 3 ("Hard pause — post-group summary and menu"), currently has a single 4-option menu template with `Branch: feature/{group-slug}`, option 1 "Finish branch — merge feature/{group-slug} → develop (or main)", option 2 "Create PR — open a pull request for this group", and a "Next up" line referencing `feature/{next-group-slug}`.

- [ ] **Step 2: Replace the hard-pause menu section**

Find:
```
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
```

Replace with:
```
**3. Hard pause — post-group summary and menu**

If this was **not** the last group, show the simplified mid-plan menu (no branch actions — the branch is still in progress):

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

If this **was** the last group, show the full menu instead — this is the only point where the branch is offered for merge or PR:

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

**Wait for user response.** After options 1 or 2 complete on the full menu, wait — do not auto-start anything further. On the mid-plan menu, only "Continue to next group" advances; "Pause here" stops and waits for the user to resume explicitly ("continue", "start group 2", etc.).
```

- [ ] **Step 3: Verify**

Read `skills/iris-ops/SKILL.md`. Confirm Step 8 part 3 now shows two distinct menu templates (mid-plan simplified, last-group full), neither contains `{group-slug}` or `{next-group-slug}`, and search the full file again for `group-slug` — expect zero matches.

- [ ] **Step 4: Commit**

```bash
git add skills/iris-ops/SKILL.md
git commit -m "feat(iris-ops): split end-of-group menu into mid-plan and last-group variants"
```

---

### Task 10: Final full-repo verification and summary

**Files:**
- Read only: `skills/iris-plan/SKILL.md`, `skills/iris-ops/SKILL.md`

- [ ] **Step 1: Confirm zero stale references remain**

Search `skills/iris-plan/SKILL.md` and `skills/iris-ops/SKILL.md` for `group-slug`. Expected: zero matches in both files.

- [ ] **Step 2: Confirm all three design changes are present**

Re-read both files in full and confirm, against `docs/superpowers/specs/2026-08-17-iris-branch-per-plan-and-blocker-protocol-design.md`:
- Change 1 (single branch per plan): branch assigned once in `iris-plan`, created once in `iris-ops` with resumed-plan detection, git flow table and Rules bullet updated, both menu templates updated
- Change 2 (conditional subfolder): `iris-plan` save step branches on group count, `iris-ops` load step checks for the subfolder first
- Change 3 (Blocker Protocol): new section present in `iris-ops`, Voice and Rules reconciled with it

- [ ] **Step 3: Report**

Summarize: all tasks complete, git log for this branch shows one commit per task, no stale `{group-slug}` references remain, all three spec changes verified present.

No commit for this task — it's a final verification checkpoint, not a code change.
