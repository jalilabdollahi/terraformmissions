# Common mistakes

- **Fixing the argument but leaving `on_failure = continue`.** The next failure will be hidden again; the validator rejects the setting.
- **Running a plain `terraform apply` after the fix.** Terraform reports "No changes" because the resource exists; the provisioner never reruns.
- **Appending `|| true` to the command.** It swallows the exit status exactly like `continue` does.
- **Writing `darkroom/batch-114.log` by hand.** The mission checks that the resource was recreated by a real provisioner run.
- **Changing the variable to a string like "20C".** The variable is numeric; the script wants the bare number.
