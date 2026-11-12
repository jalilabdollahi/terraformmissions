# Solution guide

1. `terraform plan` fails with `Unsupported attribute` for `ignore_changes`: `This object has no argument,
   nested block, or exported attribute named "contents"` (and again for `body`).
2. The attribute that holds the text of a `local_file` is `content`.
3. Change the list to `ignore_changes = [content]`. Because setup applied the previous config (24h)
   and the code now says 12h, the plan then updates only `journal/schedule.txt`.
4. `terraform apply`; `cat journal/starter-notes.txt` still has the original day 1 line and
   `cat journal/schedule.txt` says 12 hours.
