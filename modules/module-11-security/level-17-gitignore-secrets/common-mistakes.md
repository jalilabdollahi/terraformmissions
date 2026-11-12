# Common mistakes

- **Adding only `*.tfstate`.** The `.backup` file ends in `.backup`, so it is not matched; workspace state files sit under `terraform.tfstate.d/`. Use `*.tfstate.*` as well.
- **Ignoring the whole `*.tf*` family.** It hides the Terraform code, the lock file and the example file you want reviewed.
- **Keeping `.terraform.lock.hcl` in the ignore list.** Provider versions then drift between machines.
- **Ignoring `prod.tfvars` by name only.** The next secret file will be named differently; ignore by pattern.
- **Forgetting that already-committed files stay tracked.** Ignoring is not enough; run `git rm --cached` and rotate the credential.
