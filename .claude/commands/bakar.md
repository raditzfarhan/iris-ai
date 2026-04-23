# /bakar

## Agent
`bakar` → load from `agents/bakar-agent.md`

## Context to load
1. Check `.iris-ai/outputs/briefs/` for the most recent spec and brief
2. Check `.iris-ai/outputs/tasks/` for the most recent plan
3. Pass relevant context to Bakar

## Input
A tooling or infrastructure task description (e.g., "set up CI", "add a linter", "configure Docker").

## Behaviour
Bakar reads the task and existing project structure, assesses what's already in place, implements the required config or script, verifies it works, and explains how it all connects.
