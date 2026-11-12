# Debrief — conversion is strict, and strictness is your friend

Terraform converts between types automatically in many places (a number becomes a string inside a
template), but the explicit conversion functions are strict about their input. `tonumber()` accepts
only strings that are exactly a decimal number: no thousands separators, no decimal comma, no
surrounding whitespace, no words. Anything else is an error that names the offending string.

That strictness is useful, because data cleaning should be visible in the code. The mission has three
kinds of dirty input and a different treatment for each:

- **Fixable formatting** (`13,1`, ` 11.9`): normalise with `replace()` and `trimspace()`.
- **Legitimately not a number** (`DNF`, `DSQ`): test with `can()` and set it aside.
- **Everything else** you did not predict: let the plan fail rather than guess.

`can(expr)` returns true if the expression evaluates without error; `try(expr, fallback)` returns the
fallback instead. Use them narrowly. Wrapping a large expression in `try()` can hide real mistakes such
as a misspelled attribute.

The same family of functions includes `tostring()`, `tobool()`, `tolist()`, `toset()` and `tomap()`.
They fail when a value cannot be converted, for example a list of objects to a map of strings, and a
`toset()` quietly removes duplicates and ordering.

## Real-world takeaway

Anything that originates from humans or CSV exports needs a clean-up step before conversion.
Put it in one local, keep rejects visible (here, `no_time`), and test with a second dataset that
contains a case you did not think of.
