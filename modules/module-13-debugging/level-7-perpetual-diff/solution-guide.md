# Walkthrough - Album Index Churn

1. `terraform apply -auto-approve`, then immediately `terraform plan`. The plan wants to update `local_file.album_index`.
2. Read the diff of `content`: the `Generated:` line changes (a new time), and on some runs the order of the `- card` lines
   changes too. Run plan three times to see that both vary.
3. Cause 1: `timestamp()` returns the current time during every plan. Replace it with a `time_static` resource, which stores the
   time in state when it is created and then leaves it alone.
4. Cause 2: the external script builds its list from a Python `set`, whose order varies between runs (string hash
   randomisation). Make the order deterministic in Terraform with `sort(split(",", ...))`.
5. `terraform apply` once more, then `terraform plan` -> *No changes*. Type `check`.
