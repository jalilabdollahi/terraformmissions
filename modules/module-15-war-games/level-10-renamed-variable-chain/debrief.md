# Post-mortem — Karst Peak Id Rename

**Timeline.** Wednesday three PRs landed the rename layer by layer. Thursday 22:00 CI went red on an undeclared
variable at the root; each fix revealed the next mismatch one module deeper. At 23:10 the chain validated but the plan
wanted to replace the beacon and the repeater channel, which would have de-synchronised every field radio.

**Root causes.**
1. A rename spanning root, region and post modules was split into separate changes with no end-to-end plan.
2. The `terraform.tfvars` file still used the old name. For a variable that is not declared, a tfvars entry only
   produces a warning, so the value silently disappeared.
3. The new variable had a plausible default (`UNSET`), which converted a missing value into a successful plan.
4. `keepers` (and a filename derived from the value) tied the generated identifiers to the identity string.

**Lessons.** Interface renames are breaking changes for everyone who sets values from outside the code: tfvars files,
CI variables, `-var` flags and `TF_VAR_` environment variables are all keyed on the name. A clean `validate` proves the
wiring, not the values; the plan is where a lost value shows up, as replacement of anything that depends on it.

**Prevention.**
- Give identity-like variables no default so a missing value is an error, not an `UNSET`.
- Search the whole repo and CI configuration for the old name when renaming a variable.
- Land a rename as a single PR with a plan against real state.
- Add a validation block rejecting placeholder values.
