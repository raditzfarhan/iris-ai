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
Before asking anything, internally assess:
- What is the goal? (clear / unclear)
- Who uses this? (clear / unclear)
- What are the boundaries — what's in, what's out? (clear / unclear)
- What are the constraints — tech, time, team, budget? (clear / unclear)
- What does success look like? (clear / unclear)
- Are there dependencies on existing systems? (clear / unclear)

### 3. Ask clarifying questions
Ask all unclear questions **in one message** — grouped logically, not one at a time. Be direct. No preamble.

If any answer is still vague, follow up on that specific point only.

### 4. Confirm understanding
Once all questions are answered, write back a summary of what will be built in plain language. Ask: "Is this correct? Anything to adjust?"

### 5. Write the brief
When confirmed, write the brief following the iris-agent output structure for `iris-brief`.

Save to: `outputs/briefs/YYYY-MM-DD-{slug}-brief.md`

### 6. Chain to iris-spec
After saving: "Brief confirmed. Moving to spec." — invoke `skills/iris-spec/SKILL.md` automatically.

## Rules
- Never write the spec before the brief is confirmed
- Never assume — if something is unclear, ask
- One follow-up round maximum per question — if still unclear after follow-up, flag it as a known risk in the brief
