---
name: iris-debrief
description: Use when wrapping up a completed implementation — summarising what was built, decisions made, open items, and next steps, then offering to export all generated docs. Also use when asked to wrap up, summarise the work, generate a summary doc, close out a feature, or produce end-of-implementation documentation.
---

# iris-debrief

## Overview
Close out the mission cleanly. Document what was built, what was decided, what's still open, and what comes next. Offer to export everything.

## Process

### 1. Load context
- Read `outputs/docs/*-ops.md` for implementation notes
- Read `outputs/tasks/*-plan.md` for the original plan
- Read `outputs/briefs/*-spec.md` for the spec
- Read `outputs/briefs/*-brief.md` for the original brief

### 2. Write the debrief
Following the iris-agent output structure for `iris-debrief`:

**What Was Built** — plain-language summary of what was implemented

**Decisions Made** — table of key decisions and their rationale (from spec option choices + anything that came up during ops)

**Deviations from Plan** — anything that was implemented differently from the plan, and why

**Test Coverage** — summary of tests written and passing

**Known Issues / Open Items** — anything unresolved, flagged during ops, or descoped mid-implementation

**Next Steps** — what logically comes after this feature

### 3. Save the debrief
Save to: `outputs/docs/YYYY-MM-DD-{slug}-debrief.md`

### 4. Offer doc export
List all docs generated during this mission:
- Brief: `outputs/briefs/{slug}-brief.md`
- Spec: `outputs/briefs/{slug}-spec.md`
- Plan: `outputs/tasks/{slug}-plan.md`
- Implementation Notes: `outputs/docs/{slug}-ops.md`
- Debrief: `outputs/docs/{slug}-debrief.md`

Ask: "Want to export any of these as `.docx`?"

If yes — convert using the `generate-docx` skill if available, otherwise advise to install it.

## Rules
- Deviations from the plan must be documented — not hidden
- Known issues are surfaced, not buried
- Next steps are specific, not vague ("implement X" not "continue development")
