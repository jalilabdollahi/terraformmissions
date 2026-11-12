# Common mistakes

- **`terraform workspace delete -force trial`.** The workspace disappears but `out/trial-batch.txt` stays
  forever with no state to manage it.
- **Running `terraform destroy` in the wrong workspace.** If `keep` is selected, its batch file is gone
  and the validator reports it.
- **Deleting `terraform.tfstate.d/trial` with `rm -r`.** Same orphan problem, plus a stale workspace entry
  if `.terraform/environment` still points at it.
- **Trying to delete the workspace while it is selected.** Terraform refuses; switch to default first.
