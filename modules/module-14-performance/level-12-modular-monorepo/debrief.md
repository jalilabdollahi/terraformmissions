# Modular Monorepo

## What Was Broken
The `generator` module's output referenced `random_string.token.id` — an attribute that does
not exist on `random_string`. The correct attribute is `result`. Because `module.processor`
consumes `module.generator`'s output, and `module.reporter` consumes `module.processor`'s
output, the validation error cascaded through the entire dependency chain.

## The Fix
In `modules/generator/main.tf`: change `random_string.token.id` → `random_string.token.result`.

## Debugging Cascade Failures
When errors cascade through a module chain:
1. **Find the leaf module** — the one with no module dependencies (generator in this case)
2. **Read the error message carefully** — Terraform usually indicates the exact resource and attribute
3. **Fix the root cause** — fixing the leaf fixes all downstream errors automatically
4. **Validate modules independently** — `cd modules/generator && terraform validate`

## Monorepo Tradeoffs
| Aspect | Monorepo | Multi-repo |
|--------|---------|-----------|
| Atomic changes | Easy | Hard (multi-PR) |
| Module versioning | Implicit (git SHA) | Explicit (semver tags) |
| CI/CD scope | Single pipeline | Per-repo pipelines |
| Team boundaries | Harder to enforce | Easier via repo ACL |

## Key Takeaway
When debugging modular configs, start from the leaf modules and work outward. The error is
almost always in the earliest module in the dependency chain.