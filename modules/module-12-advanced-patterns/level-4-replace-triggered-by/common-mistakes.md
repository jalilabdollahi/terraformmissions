# Common mistakes

- **Using `terraform apply -replace=terraform_data.cabinet` once.** That rebuilds it today, but the
  next release will again be missed; the mission wants the rule in code.
- **Adding both resources to the list.** A calibration tweak would then rebuild the cabinet, which
  the team explicitly does not want.
- **Referencing `var.firmware`.** Variables are not allowed in `replace_triggered_by`; the entry must
  reference a managed resource or one of its attributes.
- **Moving the lifecycle block to the firmware pack.** `replace_triggered_by` goes on the object that
  should be replaced, not the object that triggers.
