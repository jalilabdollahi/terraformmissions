# Post-mortem — Harrow Tempering Hall Drift

**Timeline.** Over the weekend the tempering hall accumulated five unrecorded changes. Monday 05:30 the pre-melt
audit ran `terraform plan` and found one tainted resource plus four file differences. 06:10 on-call sorted
them; 06:40 untaint, code edits and apply; 06:55 clean plan, campaign started on time.

**Root causes.**
1. Humans edited live control files instead of the code, one of them legitimately (an approved temperature),
   but nobody updated Terraform, so a routine apply would have silently reverted a quality-lab decision.
2. `terraform taint` was used as a reflex. A tainted resource is replaced on the next apply, and for a
   generated identifier replacement means a different value.
3. A decommissioned mold stayed in the code, so it kept showing up as "to create".

**Lessons.** Drift has a direction. The plan only says "different"; deciding whether the code or the world
is right is a human judgement, and the same plan can contain both directions at once. The safe workflow is:
read the diff, classify each line, fix the code for adoptions, fix state flags (untaint) before applying,
and let apply handle the pure reverts.

**Prevention.**
- Put emergency edits in a ticket-linked pull request within the same shift.
- Scheduled `terraform plan -detailed-exitcode` in CI to catch drift before audits do.
- Treat taint as an intentional, reviewed action; `-replace` on the CLI is explicit and one-shot.
- Retire resources in the same change that decommissions the hardware.
