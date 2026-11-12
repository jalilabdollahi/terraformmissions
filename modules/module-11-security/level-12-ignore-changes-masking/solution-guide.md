# Walkthrough — Lindenhurst Gate Rules

1. `cat gate/access-rules.json` shows `"allow_from":["0.0.0.0/0"]` and mode `0666`, but `main.tf` says `10.20.0.0/16` and `0640`.
   Yet `terraform plan` reports *No changes*.
2. Look at the `lifecycle` block: `ignore_changes = all` tells Terraform to ignore any difference in every argument of the resource. Edits to
   the code never reach the real file, and the plan stays clean while reality is wide open.
3. Delete the `ignore_changes` setting (the block holds nothing else, so delete the whole `lifecycle` block). Run `terraform plan`: it now shows
   the rule change and the mode change in place.
4. `terraform apply`, confirm the file, type `check`. The validator also edits a *copy* of the code and expects the plan to notice.
