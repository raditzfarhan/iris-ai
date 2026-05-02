# /strategy

## Agent
`strategy` → load from `agents/strategy-agent.md`

## Context to load
1. Check `.iris-ai/outputs/briefs/` for the most recent spec and brief
2. Check `.iris-ai/outputs/tasks/` for the most recent plan
3. Pass relevant context to Strategy

## Input
A plan document path, architecture description, or strategic question.

## Behaviour
Strategy reads the input at a high level — direction only, no implementation detail. Assesses whether the approach solves the right problem, is proportionate, and has no obvious strategic blind spots. Delivers a verdict: proceed / reconsider / stop, plus one-paragraph rationale.
