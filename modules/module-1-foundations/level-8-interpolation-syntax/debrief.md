# Debrief — Kestrel Ridge Bulletin

**What broke.** Inside a quoted string, Terraform treats `${ ... }` as a template sequence: it evaluates
the expression and splices the result in. Anything else is literal text. The author wrote a
shell-style `$(var.station)` and a Python-style `{var.altitude_m}`, so both ended up in the file
unchanged. Terraform cannot warn about it, because those are perfectly valid characters.

**Why this bug is sneaky.** There is no error. `plan` succeeds, `apply` succeeds, and the only
symptom is wrong content downstream. That is why this mission checks the file's exact content,
and re-applies with different variable values to prove that the values are really wired in rather
than typed in.

**Bare references.** A reference needs no quoting at all when it stands alone: `content = var.station`
works, and the `"${var.station}"` wrapper is only needed when you mix the value with other text. Wrapping a
single expression is a common leftover from Terraform 0.11; it is harmless but noisy.

**Real-world takeaway.** When a generated file contains punctuation you did not expect, suspect
template syntax first. Read the first generated artifact after every apply. For multi-line output
with many variables, consider `templatefile()` with a template file, where `${...}` is the same
syntax but easier to read.
