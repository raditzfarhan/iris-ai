---
name: iris-brief
description: Use when starting a new development task or feature — clarifies requirements through targeted questions until there are zero gaps, ambiguities, or assumptions. Also use when asked to understand what to build, define requirements, gather specs, or scope a feature before implementation begins.
---

# iris-brief

## Overview
Extract a complete, unambiguous understanding of what needs to be built before a single line of spec is written. No gaps, no assumptions.

## Process

### 1. Read the input
Take the user's idea or task description from the `/iris` argument.

### 2. Identify gaps
Before asking anything, build an exhaustive internal gap list across every dimension below. Mark each as clear or unclear. Every unclear item becomes a question.

**Purpose & users**
- What is the core goal — what problem does this solve?
- Who are the users — role, technical level, internal/external?
- What is the primary user action / happy path?

**Scope & boundaries**
- What is explicitly in scope?
- What is explicitly out of scope (now or ever)?
- Are there phased deliverables or an MVP cut?

**Behaviour & features**
- What are the core features?
- What are the edge cases and error states?
- What does the UI look like — web, mobile, CLI, API only?
- Are there notifications, emails, background jobs?
- Are there roles, permissions, or access levels?

**Data & state**
- What data is created, read, updated, or deleted?
- Where does data come from — user input, third-party APIs, existing DB?
- What are the data retention or privacy requirements?

**Tech & architecture**
- What is the tech stack — language, framework, database?
- Is this greenfield or does it extend an existing codebase?
- What integrations are needed — auth providers, payment, storage, APIs?
- What are the hosting / deployment constraints?

**Non-functional requirements**
- Performance expectations — response time, throughput, concurrency?
- Availability / uptime requirements?
- Security requirements — auth method, encryption, compliance?
- Accessibility or internationalisation requirements?

**Constraints & context**
- Timeline or deadline?
- Team size and skill set?
- Budget constraints that affect tech choices?
- Any decisions already locked in?

### 3. Ask clarifying questions
Ask questions **one at a time** — never batch multiple questions in one message. Be direct. No preamble.

For each question:
- Offer 2–4 labelled options (e.g. `a)`, `b)`, `c)`) that cover the most likely answers
- Always include a final option such as `d) Other — type your own` so the user is never forced to pick from the list
- Always list pros and cons under each option — no exceptions
- Always mark one option as **★ Recommended** and explain why it is the best choice, grounded in: industry standard, widely adopted practice, or what most experienced teams use for this problem. Be specific — don't just say "it's popular", say what makes it the right call here
- Wait for the user's answer before asking the next question
- If the answer is still vague, ask one focused follow-up on that point before moving on

Example question format:
```
Which database would you use?

a) PostgreSQL
   + Battle-tested, strong consistency, great for relational data
   - Needs schema upfront, heavier ops than SQLite

b) SQLite
   + Zero setup, file-based, great for local/embedded use
   - Not suitable for concurrent writes or production multi-user apps

c) MongoDB
   + Flexible schema, easy to start with document data
   - Weaker consistency guarantees, can encourage poor data modelling

d) Other — type your own

★ Recommended: a) PostgreSQL — the industry default for production web apps. Strong consistency, proven at scale, and widely supported by hosting providers and ORMs. Unless this is a local tool or prototype, PostgreSQL is the right call.
```

**Keep asking until the gap list from Step 2 is fully resolved — every single item.** Do not move to Step 4 while anything is still unclear. There is no question limit. If an answer reveals a new gap, add it to the list and ask about it. The brief cannot be written until there is zero ambiguity across all dimensions.

### 4. Confirm understanding
Once all questions are answered, write back a summary of what will be built in plain language. Ask: "Is this correct? Anything to adjust?"

### 5. Write the brief
When confirmed, write the brief following the iris-agent output structure for `iris-brief`.

Save to: `docs/iris-ai/briefs/YYYY-MM-DD-{slug}-brief.md`

After saving, output a clickable link:
> Saved: [docs/iris-ai/briefs/YYYY-MM-DD-{slug}-brief.md](docs/iris-ai/briefs/YYYY-MM-DD-{slug}-brief.md)

### 6. Chain to iris-spec
After saving: "Brief confirmed. Moving to spec." — invoke `.claude/skills/iris-spec/SKILL.md` automatically.

## Rules
- Never write the spec before the brief is confirmed
- Never assume — if something is unclear, ask
- One question per message — never combine multiple questions
- Always offer labelled options per question; always allow a free-text escape option
- Always include pros/cons for every option — never skip them
- Always include a ★ Recommended pick with a specific, grounded reason — not generic praise
- No question limit — keep asking until every dimension in Step 2 is fully resolved
- If an answer opens a new gap, ask about it before moving on
- Follow up as many times as needed on a point — don't accept vague answers
- Do not move to confirmation until the entire gap list is empty
