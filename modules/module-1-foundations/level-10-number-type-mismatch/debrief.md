# Debrief — Gilded Heron Quiz

**What broke.** Terraform is strongly typed at the edges: variable declarations carry a type, and every
resource argument has one too. `teams` was declared `number`, and `result_count` expects a number, but
both were given the *words* "eight" and "three". Terraform has an automatic conversion between strings and
numbers, but it only works when the text actually looks like a number.

**What conversion does and does not do.** `"8"` converts to `8`, so a quoted number is accepted (and `"3"`
for `result_count` would have worked). `"eight"` cannot be parsed as a number, so you get "a number is
required". The same applies to arithmetic: `"5" + 1` is `6`, while `"five" + 1` is an error.

**Why the error shows twice.** Different checks catch different places. A variable's default is checked
against its declared type during validation; a resource argument is checked against the provider's schema.
Fix every location, not only the first one that is reported.

**Real-world takeaway.** Quoted numbers are usually a sign that a value was copied from a form, a
spreadsheet, or JSON. Prefer unquoted numeric literals in HCL, give variables explicit `type =` and
`validation` blocks so a bad value is rejected with a clear message, and read the schema (`terraform
providers schema -json` or the registry docs) when you are unsure of an argument's type.
