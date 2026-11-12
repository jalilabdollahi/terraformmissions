# Common mistakes

- **Changing `countdown_minutes` to 45 in the rehearsal file.** The output looks right, but the value no
  longer comes from the reviewed `terraform.tfvars`, and the override file is still waiting to bite.
- **Editing `terraform.tfvars` to say 5 (or deleting it).** That makes the plan "consistent" by throwing
  away the value range safety approved.
- **Hard-coding 45 into the variable default or main.tf.** It beats nothing: the auto file still overrides
  the default, and the check rejects 45 in .tf files.
- **Passing `-var countdown_minutes=45` on the command line.** It works once for you, but the nightly
  pipeline and the validator run plain `terraform apply`.
