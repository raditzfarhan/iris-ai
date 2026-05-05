# /strategy

## Agent
`strategy` → load from `agents/strategy-agent.md`

## Context to load
1. Check `docs/iris-ai/briefs/` for the most recent brief and `docs/iris-ai/specs/` for the most recent spec
2. Check `docs/iris-ai/plans/` for the most recent plan
3. Pass relevant context to Strategy

## Input
A plan document path, architecture description, or strategic question.

## Behaviour
Strategy reads the input at a high level — direction only, no implementation detail. Assesses whether the approach solves the right problem, is proportionate, and has no obvious strategic blind spots. Delivers a verdict: proceed / reconsider / stop, plus one-paragraph rationale.
