# Walkthrough - Beacon Check Trace

1. **Reproduce with a trace.**
   ```bash
   TF_LOG=TRACE TF_LOG_PATH=./tf.log terraform apply -auto-approve
   ```
   The terminal error only says `open .../index.txt/probe-...ok: not a directory`; the file `tf.log` has the full story.
2. **Find the failing call.** `grep -n "ERROR" tf.log` shows the vertex that failed. Look a few lines above it for
   `tf_rpc=ApplyResourceChange` and `tf_resource_type=local_file`. A failure during planning would show
   `tf_rpc=PlanResourceChange` (or `ValidateResourceConfig`) instead - here the plan was fine.
3. **Find the plugin version.** `grep "starting plugin" tf.log` prints the plugin path
   `.terraform/providers/registry.terraform.io/hashicorp/local/<version>/...`. The same version is in
   `.terraform.lock.hcl`.
4. **Fix the cause.** The probe filename uses `local_file.beacon_index.filename`, a *file*, as if it were a directory.
   Replace it with `dirname(local_file.beacon_index.filename)`.
5. **Write the answer** to `answers/trace.txt`:
   ```
   failed_resource=local_file.beacon_probe
   failed_rpc=ApplyResourceChange
   provider_version=<the version you found>
   ```
6. `terraform apply` once more, then type `check`.
