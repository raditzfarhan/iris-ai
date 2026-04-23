---
name: iris-spec
description: Use when translating a confirmed brief into a detailed technical specification — covering functional requirements, data models, API contracts, implementation options, and edge cases. Also use when asked to write a spec, define technical requirements, plan architecture, or decide how to implement a feature before writing code.
---

# iris-spec

## Overview
Turn the confirmed brief into a complete technical spec that leaves nothing to interpretation. Identify what skills and agents are already available for implementation. Surface implementation options with tradeoffs.

## Process

### 1. Load context
- Read the confirmed brief from `outputs/briefs/*-brief.md`
- Read project files to understand the existing codebase: stack, conventions, patterns
- Scan `skills/` directory — list all available skills and assess which apply to this feature
- Scan `agents/` directory — list all available agents and assess which apply
- Check for existing tests, CI config, coding standards

### 2. Write the spec
Following the iris-agent output structure for `iris-spec`:

**Functional Requirements** — numbered (FR-01, FR-02...), each one testable and unambiguous

**Non-Functional Requirements** — performance, security, reliability, scalability

**Data Model** — tables, fields, types, relationships, indexes

**API Contracts** — endpoints, methods, request/response shapes, auth, error codes

**Skills & Agents Available** — list which existing skills/agents from this project apply and how

**Implementation Options** — 2–3 concrete options with explicit tradeoffs. For each:
- What it involves
- Pros and cons
- Recommended or not, and why

**Edge Cases & Error Handling** — every failure mode that matters

**Out of Scope** — explicit list of what is NOT being built

### 3. Present to user
Show the spec. Ask: "Which implementation option do you prefer? Any changes to the spec?"

### 4. Revise if needed
Apply any changes. Re-present only the changed sections.

### 5. Save the spec
Save to: `outputs/briefs/YYYY-MM-DD-{slug}-spec.md`

### 6. Chain to iris-plan
After confirmed: "Spec locked. Moving to plan." — invoke `skills/iris-plan/SKILL.md` automatically.

## Rules
- Every functional requirement must be testable
- Never recommend an implementation option without explaining the tradeoff
- If existing skills/agents cover part of the implementation, reference them explicitly — do not reinvent
