# Debrief — conditions must return false, not blow up

A validation `condition` is supposed to evaluate to `true` or `false`. If evaluating it raises an
error, Terraform reports that error *instead of* your `error_message`, and the person who passed a
bad value sees something about "pattern did not match" with no hint what a good value looks like.

`regex()` is the classic trap: on a match it returns the matched text, on no match it fails. You
can use these tools to turn failure into a boolean:

- `can(expr)` — `true` if `expr` evaluates without an error, otherwise `false`. The idiom for regexes:
  `can(regex(pattern, value))`.
- `length(regexall(pattern, value)) > 0` — `regexall` returns an empty list on no match, with no error.
- `try(expr, fallback)` — evaluates `expr`, falls back on error; useful for values, less for conditions.

The same trap exists for `tonumber("x")`, `cidrhost(...)`, `jsondecode(...)` and many others: if invalid
input raises an error, wrap the check in `can()`.

Note the locals still call `regex()` directly, and that is fine: validation runs first, so by the time
`local.parts` is computed the tag is known to match.

## Real-world takeaway

User-facing error messages are part of your module's interface. Always try your validation with at least
one value that fails, and read what the operator will actually see.
