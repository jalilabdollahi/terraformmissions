# Debrief — Fete Tombola Draw

**What broke.** A `version` argument inside `required_providers` is a string in Terraform's own
constraint mini-language, parsed during `terraform init` (not by the HCL parser, which sees only a
string). That is why `terraform validate` on its own may not catch it and `init` does. Two constraints
were written in an invalid way: `=> 3.6` (arrow instead of `>=`) and `~>= 2.5` (two operators fused).

**The operators.**
- `=` or no operator: exactly that version.
- `!=`: anything except that version.
- `>`, `>=`, `<`, `<=`: comparisons, always with the angle bracket first.
- `~>`: the "pessimistic" operator. `~> 2.5` allows `2.5`, `2.6`, ... but not `3.0`; `~> 2.5.1` allows
  patch releases only.
Several constraints can be combined with commas: `">= 3.6, < 4.0"`.

**Why it matters.** Constraints are how a team agrees on which provider releases are acceptable. Too
loose and a major release can change behaviour overnight; too strict and nobody can upgrade. The
`~>` operator on the minor version is the common compromise.

**Real-world takeaway.** After a successful `init`, commit `.terraform.lock.hcl` so CI uses the exact
same build. Upgrade deliberately with `terraform init -upgrade` and review the diff, instead of
letting a loose constraint do it for you.
