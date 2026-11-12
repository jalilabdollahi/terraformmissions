# Common mistakes

- **Changing the type to `string`.** `"three"` then passes validation, but `"three" * 40` fails at plan
  time — and the mission requires `oven_count` to be a number.
- **Using `default = "3"` and leaving it quoted.** It happens to work through automatic conversion, but
  it is still a string literal pretending to be a number. Prefer the real literal.
- **Deleting the default.** The planner then asks for input on every run, and non-interactive runs fail.
- **Hard-coding `3` into the `locals` expression.** The bake plan stops responding to `-var oven_count=5`.
