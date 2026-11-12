# Common mistakes

- **Making the error message stricter and leaving the condition alone.** The message is only text; nothing changes in behaviour.
- **Checking `var.shelves` once with a `for` expression in a variable validation.** The mission requires a resource precondition, and the validator rejects `validation` blocks.
- **Removing the failing default shelves.** That makes the plan green and the policy trivially true, but the shop loses shelves; the validator requires all four to exist.
- **Using `retention_days > 30`.** A shelf kept exactly 30 days complies with the stated policy; the validator tests the boundary.
- **Inverting the public test (`each.value.public`).** Then only public shelves would pass.
