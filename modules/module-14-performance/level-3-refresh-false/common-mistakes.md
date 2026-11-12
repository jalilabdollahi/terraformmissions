# Common mistakes

- **Removing `-refresh=false` from both modes.** Drift is found, but the inner loop becomes slow
  again, and the mission expects `quick` to stay a state-only plan.
- **Running `terraform apply` to "clear" the drift first.** The audit then has nothing to find, and
  the mission checks that the deletion is still visible to the audit.
- **Replacing the flag with `-refresh=true`.** That is the default and works, but leaving the flag
  in the quick branch as `-refresh=true` makes it slow too.
- **Dropping `-detailed-exitcode` from the audit.** Plan then exits 0 even when it reports changes,
  so cron and CI cannot react to drift.
