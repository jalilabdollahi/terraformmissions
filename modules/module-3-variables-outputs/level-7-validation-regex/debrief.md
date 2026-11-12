# Debrief — validate the validator

A `validation` block turns a variable declaration into a contract, and the condition is code like
any other — it can have bugs. This one was never true for a real ticket code: it described a format
nobody uses. Because the default failed too, the error was easy to notice; a condition that is
*always true* (for example a missing anchor: `regex("[A-Z]{3}-[0-9]{4}", x)` happily accepts
`xxORC-2041yy`) is far worse because it silently accepts garbage.

Habits for writing validations:
- **Anchor** patterns with `^` and `$`. `regex()` finds a match anywhere in the string unless told otherwise.
- **Test both directions**: at least one value that must pass and several that must fail. `terraform console`
  and `terraform plan -var` are quick ways to try them.
- **Keep the message honest**: the `error_message` should describe the real rule. Here the message was
  right and the regex wrong — the player trusts the message and is stuck.
- Use `can(regex(...))` or `regexall` + `length` to get a boolean (see the next lesson on `can`).

## Real-world takeaway

Treat validation conditions like unit-tested code. Terraform 1.6+ lets you write `terraform test` files
with `expect_failures` for exactly this purpose: one run block per good value and per bad value. A
validation nobody ever saw fail is a validation you cannot trust.
