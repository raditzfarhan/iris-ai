# /ali

## Agent
`ali` → load from `agents/ali-agent.md`

## Context to load
1. Check `.iris-ai/outputs/briefs/` for the most recent spec and brief
2. Check `.iris-ai/outputs/tasks/` for the most recent plan
3. Pass relevant context to Ali

## Input
A task description, feature idea, or "implement <something>" instruction.

## Behaviour
Ali reads the input and any available spec/plan context, writes a test first, implements the minimum code to pass it, refactors if needed, runs the full test suite, and reports what was done and what might need polish.
