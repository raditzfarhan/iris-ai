# /iris

## Agent
`iris` → load from `agents/iris-agent.md`

## Routing

Parse the arguments after `/iris`:

| Input | Stage | Skill |
|---|---|---|
| `/iris <idea>` (no stage keyword) | Brief | `skills/iris-brief/SKILL.md` |
| `/iris spec` | Spec | `skills/iris-spec/SKILL.md` |
| `/iris plan` | Plan | `skills/iris-plan/SKILL.md` |
| `/iris ops` | Ops | `skills/iris-ops/SKILL.md` |
| `/iris debrief` | Debrief | `skills/iris-debrief/SKILL.md` |

If no argument is given, ask: "What are we building?"

## Context to load before executing any stage

1. Check `outputs/briefs/` for the most recent `*-brief.md` and `*-spec.md`
2. Check `outputs/tasks/` for the most recent `*-plan.md`
3. Pass relevant context to the active skill

## Chaining

Each skill defines when to chain to the next stage. The command does not force chaining — the skill controls it.
