# Walkthrough — Harbourlight Ferry

1. **Diagnose.** `terraform plan` fails with `Error: Invalid index ... The given key does not identify an
   element in this collection value: the given index is greater than or equal to the length of the collection.`
   The snippet points at `var.departures[4]` in `locals`.
2. **Count.** The default list has four times: indexes `0, 1, 2, 3`. Index `4` does not exist.
3. **Fix.** Don't just change `4` to `3` — the board must follow the list when the timetable changes.
   Use `local.last_sailing = var.departures[length(var.departures) - 1]`.
4. **Verify.** `terraform apply` and check `terraform output last_departure` is `17:30`. Try
   `terraform plan -var 'departures=["07:00","15:45"]'` and see the output follow.
