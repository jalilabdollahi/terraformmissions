# Debrief — two functions that look alike

`merge()` and `concat()` both "combine things", but for different types and with different rules.

| Function | Works on | Collision rule |
|---|---|---|
| `merge(a, b, ...)` | maps and objects | the **last** argument wins for a repeated key |
| `concat(a, b, ...)` | lists and tuples | no collisions: all elements are kept, in order |

Mixing them up gives either an immediate error (a list handed to `merge`) or, worse, nothing at all.
The reversed `merge()` in this mission is valid, produces a plausible label and is simply wrong: the
blend's grade is overwritten by the house default. No error will ever warn you. Remember the rule as
"defaults first, specifics last": the thing you want to win goes at the end.

`concat()` keeps duplicates, which is why the mission wraps it in `distinct()`. That function keeps the
first occurrence and preserves order, so the house warnings stay ahead of the blend's additions.
If order does not matter, converting through `toset()` also removes duplicates, but gives you an
unordered set.

A related trap: `merge()` is shallow. If a value is itself a map, the whole inner map is replaced
rather than combined key by key.

## Real-world takeaway

Common tags, default settings and per-environment overrides are all merge problems. Put the shared
defaults first and the most specific map last, and add a test that proves an override actually wins.
For lists of security-group IDs or CIDR blocks, use `concat()` and decide consciously whether
duplicates are acceptable.
