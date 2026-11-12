# Common mistakes

- **Deleting the failing runs.** The suite goes green with no guardrail coverage; the validator requires both negative runs and mutates the validation rules in a copy.
- **Setting a valid value in the run so no failure occurs.** Then `expect_failures` complains it never saw the expected failure.
- **Loosening the validation conditions in `label.tf`.** The mission says the rules stay; the mutant check removes a rule and expects the suite to fail.
- **Using `[variable.dose_mg]` or a bare `var.dose_mg` without brackets.** The first names no object, the second is not a list (`A static list expression is required`).
