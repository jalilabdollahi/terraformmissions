# Debrief — Ribeira River Run

**What broke.** The three files used `var.race_city`, `var.runner_count` and `var.first_bib`, but no file
contained `variable` blocks. In Terraform, using a variable does not create it; a declaration does. The error
"Reference to undeclared input variable" is Terraform telling you that the interface of the module has holes.

**All files are one module.** Terraform loads every `*.tf` file in a directory as a single module, in
alphabetical order, and merges them. File names carry no meaning to Terraform, which is why a `local.last_bib`
defined in `bibs.tf` can be used in `outputs.tf`. The community convention is `main.tf`, `variables.tf`,
`outputs.tf`, `terraform.tf` (or `versions.tf`); following it means that a new teammate knows where to look.

**Declaration details.** A good declaration has a `type`, a `description`, and a `default` only when one is
sensible. `type = number` matters here: `first_bib + runner_count - 1` is arithmetic, and without a numeric
type, a value passed as text can fail confusingly. Variables without a default become required inputs, and with `-input=false`
(as in CI) a missing value is an error rather than a prompt.

**Real-world takeaway.** Treat `variables.tf` as the module's public API. Declare everything the code reads,
document it, and use `validation` blocks for rules. When a new `var.x` is added to the code, add the declaration in
the same commit, and run `terraform validate` before pushing.
