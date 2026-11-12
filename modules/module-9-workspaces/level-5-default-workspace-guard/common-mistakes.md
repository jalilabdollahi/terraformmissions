# Common mistakes

- **Making the check message louder.** Capitals and exclamation marks do not change the exit code. Only
  a precondition or a validation can fail the run.
- **Guarding only the output.** An output precondition fails after the resources were already created in
  `terraform apply`. Put it on the resource.
- **Comparing against the fountain names.** `terraform.workspace == "fountain-a"` blocks `fountain-b`. The rule is
  "anything but default".
- **Deleting the guard and relying on discipline.** The validator tries the default workspace and expects
  a refusal.
