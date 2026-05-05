# /probe

## Agent
`probe` → load from `agents/probe-agent.md`

## Context to load
1. Check `docs/iris-ai/briefs/` for the most recent brief and `docs/iris-ai/specs/` for the most recent spec
2. Check `docs/iris-ai/plans/` for the most recent plan
3. Pass relevant context to Probe

## Input
A description of broken behaviour, an error message, or "debug <something>".

## Behaviour
Probe investigates the described problem — traces from symptom to root cause, checks logs, config, environment, and recent changes. Reports findings only: what was found, where, and what to check next. Does not fix anything.
