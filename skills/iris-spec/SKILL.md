---
name: iris-spec
description: Use when translating a confirmed brief into a detailed technical specification — covering functional requirements, data models, API contracts, implementation options, and edge cases. Also use when asked to write a spec, define technical requirements, plan architecture, or decide how to implement a feature before writing code.
---

# iris-spec

## Overview
Turn the confirmed brief into a complete technical spec that leaves nothing to interpretation. Understand the codebase fully before recommending anything — reuse and extend what exists before proposing anything new.

## Process

### 1. Read the brief
- Read the confirmed brief from `docs/iris-ai/briefs/*-brief.md`
- Extract the core nouns and verbs — these are your search terms for step 2 (e.g. "user authentication" → search for `auth`, `login`, `user`, `session`)

### 2. Explore the codebase
Use the brief's search terms to actively investigate what already exists. Do not skim — read the relevant files in full.

**Stack and structure**
- Identify the framework, language, folder conventions, and entry points
- Read config files, `package.json` / `composer.json` / `pyproject.toml`, etc.
- Note the existing folder structure for features similar to this one

**Existing implementation**
For each concept in the brief, search for:
- Functions, methods, or classes that already do this or something close
- Services, repositories, or helpers that could be extended
- Existing routes, controllers, or handlers in the same domain
- Database tables, models, or schemas related to the feature
- Utility functions that could be reused

**Patterns and conventions**
- How are similar features structured? (e.g. if there's already a `UserService`, a new feature likely needs a similar service)
- What naming conventions are used?
- How is error handling done in existing code?
- How are tests written and organised?

**Skills and agents**
- Scan `skills/` — list available skills and assess which apply
- Scan `.claude/agents/` — list available agents and assess which apply

**Produce a codebase summary before moving on:**
```
Codebase context:
- Stack: {framework, language, key dependencies}
- Relevant existing code:
  - {file/function}: {what it does, how it relates to this feature}
  - {file/function}: {reusable / extendable / replace}
- Patterns to follow: {naming, structure, error handling}
- Test setup: {framework, location, conventions}
- Gaps: {what does not exist yet and must be built fresh}
```

### 3. Surface implementation options
With full codebase context in hand, present 2–3 implementation options:

For each option:
- What it involves (one sentence)
- What existing code it reuses or extends
- What needs to be built fresh
- Pros and cons
- Mark one as **Recommended** — default to the option that reuses the most existing code while meeting the requirements cleanly

Ask: "Which approach do you want to go with?" — wait for the user to pick before writing the spec.

### 4. Write the spec
Once the user has chosen an implementation direction, write the full spec:

**Codebase Context** — what already exists that this feature builds on; what will be reused, extended, or replaced

**Functional Requirements** — numbered (FR-01, FR-02...), each one testable and unambiguous

**Non-Functional Requirements** — performance, security, reliability, scalability

**Data Model** — tables, fields, types, relationships, indexes (mark each as existing / extended / new)

**API Contracts** — endpoints, methods, request/response shapes, auth, error codes (mark each as existing / extended / new)

**Skills & Agents Available** — list which existing skills/agents from this project apply and how

**Chosen Implementation Approach** — the option the user selected, with a brief rationale

**Edge Cases & Error Handling** — every failure mode that matters

**Out of Scope** — explicit list of what is NOT being built

### 5. Present to user
Show the written spec. Ask: "Does this look right? Anything to adjust?"

### 6. Revise if needed
Apply any changes. Re-present only the changed sections.

### 7. Save the spec
Save to: `docs/iris-ai/specs/YYYY-MM-DD-{slug}-spec.md`

After saving, output a clickable link:
> Saved: [docs/iris-ai/specs/YYYY-MM-DD-{slug}-spec.md](docs/iris-ai/specs/YYYY-MM-DD-{slug}-spec.md)

### 8. Chain to iris-plan
After confirmed: "Spec locked. Moving to plan." — invoke `.claude/skills/iris-plan/SKILL.md` automatically.

## Rules
- Explore the codebase before forming any opinion — never recommend an approach without knowing what already exists
- Default to reuse and extension over creating new code; only build fresh when nothing relevant exists
- Every functional requirement must be testable
- Never recommend an implementation option without explaining the tradeoff and what it reuses vs builds new
- If existing skills/agents cover part of the implementation, reference them explicitly — do not reinvent
