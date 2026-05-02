---
name: iris-debrief
description: Use when wrapping up a completed implementation — summarising what was built, decisions made, open items, and next steps, then offering to export all generated docs. Also use when asked to wrap up, summarise the work, generate a summary doc, close out a feature, or produce end-of-implementation documentation.
---

# iris-debrief

## Overview
Close out the mission cleanly. Document what was built, what was decided, what's still open, and what comes next. Offer to export everything.

## Process

### 1. Load context
- Read `.iris-ai/outputs/docs/*-ops.md` for implementation notes
- Read `.iris-ai/outputs/tasks/*-plan.md` for the original plan
- Read `.iris-ai/outputs/specs/*-spec.md` for the spec
- Read `.iris-ai/outputs/briefs/*-brief.md` for the original brief

### 2. Write the debrief
Following the iris-agent output structure for `iris-debrief`:

**What Was Built** — plain-language summary of what was implemented

**Decisions Made** — table of key decisions and their rationale (from spec option choices + anything that came up during ops)

**Deviations from Plan** — anything that was implemented differently from the plan, and why

**Test Coverage** — summary of tests written and passing

**Known Issues / Open Items** — anything unresolved, flagged during ops, or descoped mid-implementation

**Next Steps** — what logically comes after this feature

### 3. Save the debrief
Save to: `.iris-ai/outputs/docs/YYYY-MM-DD-{slug}-debrief.md`

After saving, output a clickable link:
> Saved: [.iris-ai/outputs/docs/YYYY-MM-DD-{slug}-debrief.md](.iris-ai/outputs/docs/YYYY-MM-DD-{slug}-debrief.md)

### 4. Offer merge back to base branch
Following git flow, the feature branch should be merged back to `develop` (or `main` if there is no `develop`).

Ask: "All done. Do you want to merge `feature/{slug}` back to `develop`?"

If yes:
1. Run the full test suite one final time — do not merge with a red suite
2. Switch to the base branch: `git checkout develop`
3. Pull latest: `git pull`
4. Merge the feature branch: `git merge --no-ff feature/{slug}` (always `--no-ff` to preserve the feature boundary in history)
5. Confirm the merge succeeded and report: `Merged feature/{slug} into develop.`
6. Ask: "Delete the feature branch? (`git branch -d feature/{slug}`)"

If no — leave the branch as-is and note it in the debrief under **Next Steps**.

### 5. Offer doc export
List all docs generated during this mission:
- Brief: `.iris-ai/outputs/briefs/{slug}-brief.md`
- Spec: `.iris-ai/outputs/specs/{slug}-spec.md`
- Plan: `.iris-ai/outputs/tasks/{slug}-plan.md`
- Implementation Notes: `.iris-ai/outputs/docs/{slug}-ops.md`
- Debrief: `.iris-ai/outputs/docs/{slug}-debrief.md`

Ask: "Want to export any of these as `.docx`?"

If yes — convert using the `generate-docx` skill if available, otherwise advise to install it.

## Rules
- Deviations from the plan must be documented — not hidden
- Known issues are surfaced, not buried
- Next steps are specific, not vague ("implement X" not "continue development")
- Always use `--no-ff` when merging — never fast-forward, so the feature history is preserved
- Never merge with a failing test suite
