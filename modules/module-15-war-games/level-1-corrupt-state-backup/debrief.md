# Post-mortem — Meridian Dish Blackout

**Timeline.** 02:40 CI applied the west dish and retuned north. 02:41 the runner's disk reached 100% while
Terraform flushed `terraform.tfstate`; the file was left truncated. 03:12 the correlator alarm fired when an
on-call engineer's plan failed on a JSON parse error. 03:50 state restored from the backup and the west
serial re-imported. 04:20 clean plan, array back before the 06:00 block.

**Root causes.**
1. State lived on the runner's local disk with no free-space monitoring and no remote versioned backend.
2. Truncation is not survivable by Terraform: `terraform.tfstate.backup` is the only safety net and it
   always lags one apply behind.
3. The obvious reflex, deleting state and re-applying, would have regenerated every random serial that is
   physically burned into dish firmware.

**What the recovery taught.** A restored backup describes the world as of the *previous* apply. Everything
changed by the last apply has to be reconciled from other evidence: files on disk, the plan diff, the
cloud console. Here the plan's lone "create" for the west dish was the clue, and the calibration file the
last apply wrote carried the identity needed for `terraform import`.

**Prevention.**
- A remote backend with versioning (or at minimum a pre-apply `terraform state pull` snapshot in CI).
- Disk and inode alerts on any machine that writes state.
- Treat `.backup` as a one-shot: copy it away before running any further command.
- Keep identity values that cannot be regenerated in a place that survives state loss.
