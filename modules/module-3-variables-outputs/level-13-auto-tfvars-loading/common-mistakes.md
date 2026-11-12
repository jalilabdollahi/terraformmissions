# Common mistakes

- **Editing the defaults in variables.tf to 24 / auto / 6.** The apply "works", but the winter baseline
  is lost and the summer settings are now hard-coded in the module code. The mission checks the defaults.
- **Running `terraform apply -var-file=prod.tfvars` once by hand.** Fine for you today, but the nightly job
  runs without flags and the validator also runs plain `terraform apply`.
- **Renaming to `prod.tfvars.auto`.** The suffix must be exactly `.auto.tfvars`; `prod.tfvars.auto` isn't loaded.
- **Naming it `auto.tfvars`.** That works, but only because it ends with `.auto.tfvars`; placing `prod` before
  it makes the purpose clear.
