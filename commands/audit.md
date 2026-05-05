# /audit

## Agent
`audit` → load from `agents/audit-agent.md`

## Context to load
1. Check `docs/iris-ai/briefs/` for the most recent brief and `docs/iris-ai/specs/` for the most recent spec
2. Check `docs/iris-ai/plans/` for the most recent plan
3. Pass relevant context to Audit

## Input
A file path, module name, or "audit <something>" for a security review. Or a plan/architecture doc for an architecture review.

## Behaviour
Audit runs the full security and architecture checklist against the target, lists every finding with severity and required fix, and does not move on until all issues are surfaced.
