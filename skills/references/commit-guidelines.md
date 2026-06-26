# Commit Guidelines

Reference for all IRIS-driven development. Follow these rules on every commit.

---

## Frequency Rule

Commit at logical checkpoints — do not wait for a whole task group to finish.

Commit when:
- A test goes from red to green
- A self-contained feature slice works end-to-end
- A bug is fixed and verified
- A refactor step is complete

Do not batch multiple tasks into a single commit.

---

## 50/72 Formatting Rule

| Part | Rule |
|---|---|
| Subject line | ≤ 50 characters |
| Subject ↔ body separator | Blank line (mandatory if body is present) |
| Body lines | Wrapped at 72 characters |
| Subject trailing punctuation | No period at the end |

The subject line is what appears in `git log --oneline`. Keep it scannable.

---

## Conventional Commits

Format: `type(scope): description`

- `scope` is optional — omit the parentheses if not needed
- `description` is lowercase, imperative mood ("add", not "added" or "adds")
- Entire subject line must stay ≤ 50 characters

### Canonical types

| Type | Use for |
|---|---|
| `feat` | A new feature or capability |
| `fix` | A bug fix |
| `refactor` | Code restructuring with no behaviour change |
| `test` | Adding or updating tests |
| `docs` | Documentation changes only |
| `chore` | Maintenance tasks (deps, config, tooling) |
| `style` | Formatting, whitespace — no logic change |
| `ci` | CI/CD pipeline changes |
| `perf` | Performance improvements |
| `build` | Build system or external dependency changes |

### Breaking changes

Append `!` after the type/scope and add a `BREAKING CHANGE:` footer:

```
feat!: remove legacy auth endpoint

BREAKING CHANGE: /api/v1/auth is removed. Use /api/v2/auth instead.
```

### Issue references (footer)

```
Fixes #123
Closes #456
```

---

## Commit Message Template

```
<type>(<scope>): <subject>          ← keep entire line ≤ 50 chars
                                    ← blank line (required if body present)
<body>                              ← explain WHY, not WHAT; wrap at 72 chars
                                    ← blank line (required if footer present)
<footer>                            ← BREAKING CHANGE: or Fixes #N
```

### Example — simple

```
fix(auth): handle expired token on refresh
```

### Example — with body

```
feat(search): add fuzzy matching to user lookup

Exact-match was missing users with slight name variations.
Fuzzy matching uses Levenshtein distance ≤ 2 to catch typos
and partial matches without impacting query performance.
```

### Example — breaking change

```
refactor!: replace session tokens with JWTs

BREAKING CHANGE: existing session tokens are invalidated.
All clients must re-authenticate after this deploy.

Closes #88
```
