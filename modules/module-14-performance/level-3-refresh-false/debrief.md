# Debrief — a skipped refresh is a skipped look at reality

By default `terraform plan` refreshes first: it asks every provider to read the real object and
updates state, then compares code to that fresh picture. `-refresh=false` skips the reads and trusts
the state file. On a large estate that can turn a plan from minutes into seconds, so it is a
legitimate speed-up, and it is **safe when you are checking what your own code change does** against
infrastructure nobody else touches.

It is **unsafe whenever the question is "has anything changed behind our back?"** The deleted setpoint
file is exactly that. Terraform's stale belief that the file exists means the plan is clean and the
monitoring cron stays green for as long as the flag is there.

A workable split for teams:

- Inner loop (editing, reviewing a PR): `-refresh=false` is fine, optionally with `-target` for
  a single module while debugging.
- Pre-apply plan, the one that gets approved: always refreshed.
- Scheduled drift audit: refreshed, using `-detailed-exitcode` so exit 2 can page someone; add
  `-refresh-only` if you want a report limited to out-of-band changes.

Real-world takeaway: put the mode in the script name or argument, not in somebody's shell history,
and make sure the one that detects drift is the one that reads reality. A copied flag in a wrapper
script is exactly how a "green" audit goes stale for months.
