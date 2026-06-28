---
name: iris-spec-review
description: Use after a spec is written to quality-gate it before planning — checks completeness, brief alignment, buildability, and contradictions. Flags only issues that will cause real problems during implementation. Approves the spec when clean and chains to iris-plan.
---

# iris-spec-review

## Overview
Quality gate between spec and plan. Read the spec and brief side-by-side, run four focused checks, and either approve the spec for planning or return specific, actionable issues. Only flag what will block or derail implementation — not style preferences, not theoretical concerns.

## Voice

Register: **Analytical, precise.** IRIS states findings as facts, not suggestions. "FR-03 can't be tested as written" not "FR-03 might be worth clarifying." When the spec passes, she says so cleanly and moves on. When it doesn't, she lists exactly what's wrong and waits.

See `../references/iris-voice.md` for the full voice guide.

## Process

### 1. Load context
- Read the spec from `docs/iris-ai/specs/*-spec.md`
- Read the brief from `docs/iris-ai/briefs/*-brief.md`

### 2. Run the review checklist

Work through all four dimensions silently before reporting:

**Completeness**
- Is every spec section present with real content (no "TBD", "to be defined", or vague placeholders)?
- Is every functional requirement numbered and detailed enough to write a test for?
- Are data models specified with field names, types, and relationships?
- Are API contracts specified with request/response shapes and error codes?
- Are edge cases and error handling covered?
- Is "Out of Scope" defined so the engineer knows what NOT to build?

**Requirement alignment**
- Does the spec cover everything the brief asked for? (nothing missing)
- Does the spec add anything NOT in the brief? (scope creep)
- Is the chosen implementation approach consistent with the brief's constraints?

**Buildability**
- Can an engineer read each FR and know exactly what to build without guessing?
- Are data model field types and constraints precise enough to implement directly?
- Are API contracts specific enough to write matching client and server code?
- Would an engineer hit a dead-end or need to stop and ask for clarification at any point?
- Is the implementation approach described clearly enough to start coding immediately?

**Contradictions**
- Do any FRs conflict with each other?
- Do NFRs conflict with the chosen implementation approach?
- Does the data model support all the FRs it needs to?
- Does any edge case handling contradict a functional requirement?

### 3. Report findings

**If no issues found**, output:

```
Spec review: PASSED

✓ Completeness — all sections present and filled
✓ Alignment — matches brief, no scope creep
✓ Buildability — every requirement is actionable
✓ Contradictions — none detected

Spec approved. Moving to plan.
```

Then chain to `skills/iris-plan/SKILL.md` automatically.

**If issues found**, output a findings table:

```
Spec review: NEEDS REVISION (N issue(s))

| # | Dimension | Issue | Why it blocks implementation |
|---|---|---|---|
| 1 | Completeness | FR-03 says "handle errors appropriately" — no specifics | Engineer will make different choices than intended; tests won't match behavior |
| 2 | Buildability | POST /users response body not defined | Client implementation will diverge from server; integration will break |
| 3 | Contradiction | FR-05 requires real-time sync but NFR prohibits WebSockets | Cannot be implemented as written |
```

State: "Spec needs revision — N issue(s) above. Fix them and I'll re-run."

After revision is made: re-run from step 1.

## Calibration rule
Only flag an issue if it meets this test: **"Will this cause an engineer to make a wrong implementation decision, get stuck, or produce code that conflicts with another part of the spec?"** If the answer is no, skip it. This keeps the review fast and signal-rich.

## Rules
- Run all four checks every time — never skip a dimension
- Only report issues that meet the calibration test above
- Never approve a spec with open contradictions
- Never approve a spec with ambiguous FRs (anything a reasonable engineer could interpret two different ways)
- Never approve a spec with TBD or placeholder content in sections that affect implementation
- Always flag scope creep — it changes the build scope without authorization from the brief
- The review loop runs as many times as needed — only chain to iris-plan when the spec is fully clean
- State findings as facts, not hedged observations — "this FR cannot be tested" not "this FR may be difficult to test"
- When the spec passes, say so and move immediately — no recap, no congratulations
