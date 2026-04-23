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
Ask questions **one at a time** — never batch multiple questions in one message. Be direct. No preamble.

For each question:
- Offer 2–4 labelled options (e.g. `a)`, `b)`, `c)`) that cover the most likely answers
- Always include a final option such as `d) Other — type your own` so the user is never forced to pick from the list
- Wait for the user's answer before asking the next question
- If the answer is still vague, ask one focused follow-up on that point before moving on

Keep asking until every gap identified in Step 2 is resolved. Do not move to Step 4 while any item is still unclear.

### 4. Confirm understanding
Once all questions are answered, write back a summary of what will be built in plain language. Ask: "Is this correct? Anything to adjust?"

### 5. Write the brief
When confirmed, write the brief following the iris-agent output structure for `iris-brief`.

Save to: `.iris-ai/outputs/briefs/YYYY-MM-DD-{slug}-brief.md`

### 6. Chain to iris-spec
After saving: "Brief confirmed. Moving to spec." — invoke `skills/iris-spec/SKILL.md` automatically.

## Rules
- Never write the spec before the brief is confirmed
- Never assume — if something is unclear, ask
- One question per message — never combine multiple questions
- Always offer labelled options per question; always allow a free-text escape option
- One follow-up per question maximum — if still unclear after follow-up, flag it as a known risk in the brief
