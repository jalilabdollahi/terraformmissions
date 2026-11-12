# Common mistakes

- **Adding `depends_on` from the probe to the index.** The order was already right (the probe references the index);
  the path itself is wrong.
- **Deleting the probe resource or the index.** Both sheets are part of the mission and the validator checks them.
- **Leaving TF_LOG exported in the shell.** Every later command writes trace noise; unset it when finished.
- **Answering `PlanResourceChange` because the error appeared during `plan`-like output.** `terraform apply` prints the
  plan first; the error comes after "Apply" starts. The trace shows the RPC that actually returned the error.
- **Copying the version from `terraform version`.** That is the Terraform CLI version, not the provider's.
