# /alicia

## Agent
`alicia` → load from `agents/alicia-agent.md`

## Context to load
1. Check `.iris-ai/outputs/briefs/` for the most recent spec and brief
2. Check `.iris-ai/outputs/tasks/` for the most recent plan
3. Pass relevant context to Alicia

## Input
A file path to review, or "review last task" to review the most recently completed task.

## Behaviour
Alicia reads the target file(s) and the spec, runs her full review checklist (vs spec, vs plan, code quality, surface-level security and performance), and reports a structured findings list with severity labels.
