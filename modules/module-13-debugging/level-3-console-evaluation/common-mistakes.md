# Common mistakes

- **Hard-coding the answer** (`["HERON-3", ...]`). The planning sheet must follow the CSV when passes change.
- **Wrapping the minutes in `tonumber()` before `sort()`.** `sort` converts them straight back to strings; the order
  stays alphabetical.
- **Fixing only the loud error.** After the `...` fix everything evaluates, but the booking sheet still lists the
  wrong satellites. Check the values, not just the exit code.
- **Dropping the elevation filter** to "simplify" the expression. KESTREL-2 and TERN-7 are unusable passes.
- **Comparing `p.elevation > 30` on text and assuming it is numeric ordering.** It works here only because Terraform
  converts the string implicitly; use `tonumber()` to be explicit.
