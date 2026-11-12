# Debrief - test the refusal, not just the acceptance

Preconditions (and postconditions) are guardrails attached to a resource, data source or output through
`lifecycle`. If the condition is false, Terraform stops with a custom error. They are a different kind of
check from variable validation because they can look at several inputs or at other resources together, and
they belong to the object they protect. In tests, `expect_failures` accepts these objects directly:
`terraform_data.display_permit`, `data.some.thing`, `output.name`, or `check.name`.

Two ways to get the negative test wrong appear in this level. Naming the **wrong object**, such as the
variable that feeds the rule, means the real failure is "unexpected" and the one you expected never happens;
Terraform reports both errors, which is the signature to remember. And **not breaking the rule at all**:
if the override does not violate the condition, the plan succeeds and Terraform complains that the expected
failure is missing. A negative test that cannot fail would otherwise be a quiet false pass, so the framework
fails it.

Each negative run should break exactly one rule so it can attribute the failure. Here `too_heavy` changes only the
weight and `too_tall` only the height; if a run broke both, one expected address would cover two different
messages and a future change to one rule could go unnoticed.

Real-world takeaway: for every precondition and postcondition write one positive run and one negative
run that expects the failure on the resource itself. The negative runs are your proof the guardrails are still
armed after refactors.
