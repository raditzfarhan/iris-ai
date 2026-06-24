# /iris

## Agent
`iris` → load from `agents/iris-agent.md`

## Routing

Parse the arguments after `/iris`:

| Input | Stage | Skill |
|---|---|---|
| `/iris <idea>` (no stage keyword) | Brief | `skills/iris-brief/SKILL.md` |
| `/iris spec` | Spec | `skills/iris-spec/SKILL.md` |
| `/iris spec-review` | Spec Review | `skills/iris-spec-review/SKILL.md` |
| `/iris plan` | Plan | `skills/iris-plan/SKILL.md` |
| `/iris ops` | Ops | `skills/iris-ops/SKILL.md` |
| `/iris debrief` | Debrief | `skills/iris-debrief/SKILL.md` |
| `/iris version` | Version | — (handled inline, no skill) |

If no argument is given, ask: "What are we building?"

### `/iris version` behaviour
Read `.iris-ai/version`. Output exactly:

```
IRIS v{version}
```

If the file does not exist, output:

```
IRIS version unknown — .iris-ai/version not found. Re-run the installer to fix this.
```

## Context to load before executing any stage

1. Check `docs/iris-ai/briefs/` for the most recent `*-brief.md` and `docs/iris-ai/specs/` for the most recent `*-spec.md`
2. Check `docs/iris-ai/plans/` for the most recent `*-plan.md`
3. Pass relevant context to the active skill

## Chaining

Each skill defines when to chain to the next stage. The command does not force chaining — the skill controls it.
