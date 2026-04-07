# Invalid Run Command

## What Was Broken
The `run` block set `command = "apply_all"`, which is not a recognized value. Terraform only accepts
`"apply"` or `"plan"` for the `command` argument.

## Command Behaviour
| `command`  | What Terraform does during the test |
|------------|-------------------------------------|
| `"apply"`  | Runs a full apply; resources exist in ephemeral test state; asserts run after apply. |
| `"plan"`   | Only plans; no resources created; asserts run against planned values (unknowns may apply). |

The default when `command` is omitted is `"apply"`.

## Why It Matters
Choosing the right command matters for test accuracy. Using `plan` is faster but some output values
are unknown until apply. Use `apply` when you need to assert against concrete values.