# Post-mortem - the quota blackout

**Timeline.** Monday: security rotates the quota-registry token. Tuesday 02:00: the nightly run is interrupted while the stamp
provisioner is waiting on the registry; the object is tainted. Wednesday 02:00: plan fails before it begins.

**Root causes.**
1. An external credential expired and the pipeline had no early check; the failure was discovered at plan time, because
   `data "external"` runs the program during planning, not apply.
2. Terraform shows only the program's stderr. The program wrote its real reason to a log file; the first minutes were spent
   reading the wrong place.
3. Two defects were stacked: a bad credential masked a bad variable default (`north_sea`), and neither had been exercised since
   the last refactor.
4. The failed provisioner left a tainted object; its output file looked plausible, but it was a half-written stamp.

**How Terraform behaves.** The external provider treats a non-zero exit or invalid JSON as an error and echoes stderr. A
provisioner that fails marks the resource tainted, so the next apply will destroy and recreate it, which is exactly what
should happen to a half-finished stamp but never to untouched resources such as the vessel key.

**Prevention.**
- Give external programs useful stderr and exit codes; log files are a second place to look, not the only one.
- Track credential expiry and rotate through a defined channel (env var or ignored file), never through code or state.
- Cover the pipeline with a scheduled `terraform plan` so expired credentials surface during working hours.
- After an interrupted apply, read the plan: a replace for a tainted object is the recovery, a replace for anything else is not.
