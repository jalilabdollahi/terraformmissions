# Debrief — Quayside Lane Bookings

**What broke.** Every top-level construct in HCL starts with a *block type* keyword. Terraform has a
small fixed vocabulary: `terraform`, `provider`, `resource`, `data`, `variable`, `locals`, `output`,
`module`, `moved`, `import`, `removed`, `check`. Anything else at the top level is an
"Unsupported block type" error. Two blocks here used `varible` and `outputs`, both close enough that
a human reads them without noticing.

**Why the message is helpful.** Terraform compares what you wrote against its list and suggests the
nearest match: `Did you mean "variable"?`. It is almost always right, so read that line before you start
hunting.

**Plural traps.** `output` and `variable` are singular because each block declares exactly one
thing; `locals` is plural because one block holds many named values. Mixing those up is the most
common keyword mistake, and it also appears in references: `var.x` is singular while the declaration
is `variable`.

**Real-world takeaway.** Syntax-level typos are caught by `terraform validate` in a second. Make it
a pre-commit habit, and use an editor with the Terraform language server: it underlines unknown block
types as you type, long before you run any command. The variable must also stay wired in: the validator
re-applied with a different `lane` value to prove the input still drives the file.
