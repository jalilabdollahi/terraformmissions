# Walkthrough - Community Board Tug of War

1. `terraform apply`, then `terraform plan`. One of the two resources shows up as `will be created` again (the provider found its file changed, so it dropped it from state). Apply again and look at the plan:
   it is now the other one. That alternation is the signature of two resources fighting over one object.
2. Confirm: `grep -n board_file main.tf` shows both resources use `local.board_file` as `filename`.
   `terraform state list` has two entries for one file on disk.
3. The `local_file` resource compares the real file's content with its own `content` argument on refresh. Whichever resource wrote first
   is "drifted" the moment the second one overwrites the file.
4. Give the file one owner: a single resource named for what it is, with content built from both pieces:
   `"${local.intro}\n## Events\n${join(...)}\n"`.
5. Run `terraform apply`. Terraform destroys the two old entries (the file is rewritten by the new resource) and creates the single owner.
   A second `terraform plan` shows no changes. `check`.
