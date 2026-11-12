# Post-mortem - the overwritten rota state

**Timeline.** Wednesday 14:02 CI run 217 creates a repair rack for the heron; the state upload times out. Thursday
09:15 another team restores an old state file onto the shared VM. Thursday 09:40 the rota plan wants to create three
objects that already exist.

**Root causes.**
1. State lived as a plain file on a shared machine; anyone with shell access could replace it, and nothing locked or
   versioned it.
2. The CI pipeline treated the state upload as a separate step. When it failed, the only record of the new rack was a log.
3. Copies of state circulated with names that mentioned a time, not a lineage or serial.

**How Terraform behaves.** Every state carries a `lineage` (identity of the state history) and a `serial` (revision).
`terraform state push` refuses to overwrite a state of a different lineage, and refuses a lower serial; `-force` disables
both checks. Highest serial is therefore not a measure of correctness: only same-lineage copies compete, and among them
the freshest valid file wins. Anything created after that copy is unmanaged until you adopt it, and `import` needs the
provider-specific id (for random_integer: `result,min,max`).

**Prevention.**
- Use a remote backend with locking and versioning (S3 with versioning, Terraform Cloud, GCS) so an old copy is never "the
  only copy".
- Make uploading state part of the same job as apply, and fail the pipeline loudly when it fails.
- Inspect lineage and serial before every `state push`; never force without a second pair of eyes.
