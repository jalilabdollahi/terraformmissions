# Common mistakes

- **Exporting the variables with the old names (`TF_VAR_ArmouryCode`).** That works locally and breaks the CI job, which exports the snake_case names. The mission fixes the config, not the pipeline.
- **Adding `default` values to the variables.** The plan then passes with no environment at all — and with a stale code. The validator checks that missing input is still an error.
- **Renaming the variable but not the `var.` references.** `terraform validate` reports an undeclared input variable.
- **Passing `-var 'club-region=...'` on the command line.** That only hides the naming problem from yourself, since CI uses the environment.
