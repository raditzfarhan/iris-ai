---
name: iris-spec
description: Use when translating a confirmed brief into a detailed technical specification — covering functional requirements, data models, API contracts, implementation options, and edge cases. Also use when asked to write a spec, define technical requirements, plan architecture, or decide how to implement a feature before writing code.
---

# iris-spec

## Overview
Turn the confirmed brief into a complete technical spec that leaves nothing to interpretation. Identify what skills and agents are already available for implementation. Surface implementation options with tradeoffs.

## Process

### 1. Load context
- Read the confirmed brief from `.iris-ai/outputs/briefs/*-brief.md`
- Read project files to understand the existing codebase: stack, conventions, patterns
- Scan `skills/` directory — list all available skills and assess which apply to this feature
- Scan `.claude/agents/` directory — list all available agents and assess which apply
- Check for existing tests, CI config, coding standards

### 2. Surface implementation options
Before writing anything, present the 2–3 implementation options to the user:

For each option:
- What it involves (one sentence)
- Pros and cons
- Mark one as **Recommended** with a clear reason (industry fit, simplicity, project context)

Ask: "Which approach do you want to go with?" — wait for the user to pick before writing the spec.

### 3. Write the spec
Once the user has chosen an implementation direction, write the full spec following the iris-agent output structure for `iris-spec`:

**Functional Requirements** — numbered (FR-01, FR-02...), each one testable and unambiguous

**Non-Functional Requirements** — performance, security, reliability, scalability

**Data Model** — tables, fields, types, relationships, indexes

**API Contracts** — endpoints, methods, request/response shapes, auth, error codes

**Skills & Agents Available** — list which existing skills/agents from this project apply and how

**Chosen Implementation Approach** — the option the user selected, with a brief rationale

**Edge Cases & Error Handling** — every failure mode that matters

**Out of Scope** — explicit list of what is NOT being built

### 4. Present to user
Show the written spec. Ask: "Does this look right? Anything to adjust?"

### 5. Revise if needed
Apply any changes. Re-present only the changed sections.

### 6. Save the spec
Save to: `docs/iris-ai/specs/YYYY-MM-DD-{slug}-spec.md`

After saving, output a clickable link:
> Saved: [docs/iris-ai/specs/YYYY-MM-DD-{slug}-spec.md](docs/iris-ai/specs/YYYY-MM-DD-{slug}-spec.md)

### 7. Chain to iris-plan
After confirmed: "Spec locked. Moving to plan." — invoke `.claude/skills/iris-plan/SKILL.md` automatically.

## Rules
- Every functional requirement must be testable
- Never recommend an implementation option without explaining the tradeoff
- If existing skills/agents cover part of the implementation, reference them explicitly — do not reinvent
