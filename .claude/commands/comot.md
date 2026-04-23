# /comot

## Agent
`comot` → load from `agents/comot-agent.md`

## Context to load
1. Check `.iris-ai/outputs/briefs/` for the most recent spec and brief
2. Check `.iris-ai/outputs/tasks/` for the most recent plan
3. Pass relevant context to Comot

## Input
A description of broken behaviour, an error message, or "debug <something>".

## Behaviour
Comot investigates the described problem — traces from symptom to root cause, checks logs, config, environment, and recent changes. Reports findings only: what was found, where, and what to check next. Does not fix anything.
