# Walkthrough — Cinder Valley Watch Roster

1. `terraform apply` succeeds with an empty `rosters/tonight.txt`; `watch_list` is `[]`.
2. In `terraform console`:
   ```
   > true == "true"                    # false  (== does not convert types)
   > true && 25 >= 25                  # true
   > [for n in [10, 25, 30] : n if n > 25]    # [30]    strictly greater
   > [for n in [10, 25, 30] : n if n >= 25]   # [25,30] at least
   ```
3. Change the condition to `t.staffed && t.height_m >= var.min_height_m`. The first part fixes the
   empty roster; the second counts Tamarack, which is exactly 25 m.
4. Apply and run `check`.
