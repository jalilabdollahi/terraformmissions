# Debrief - test the shape of a secret, not the secret

Terraform lets assertions read sensitive values: the condition is evaluated normally. What it protects is
what you *see*. If a sensitive value reaches the failure diff, it is replaced by `(sensitive value)`, and an
`error_message` that mentions a sensitive value is dropped entirely with a warning. That is exactly the
behaviour you want in CI logs, and exactly what makes a failing test hard to debug.

The way out is not to wrap the secret in `nonsensitive()`. That prints the secret into logs that
many people can read. Instead, assert on **derived, non-secret facts**: its length, that it matches
`^[0-9]{8}$`, that it is different from another secret, that it starts with an agreed prefix. The
derived fact can be unmasked with `nonsensitive()` when you are sure it reveals nothing, for example the
length of a fixed-length code.

Assertions about shape are also more useful than assertions about value. A random lock code has no
expected value, and a hard-coded literal in a test file is a secret in your repository history. Shape
survives every regeneration and documents the policy: eight digits, numeric only.

Real-world takeaway: write secret-handling tests so that a failure tells you which policy broke (length,
alphabet, uniqueness) without ever printing the secret. Treat `nonsensitive(secret)` in a test as a bug, and
`nonsensitive(length(secret))` as a tool.
