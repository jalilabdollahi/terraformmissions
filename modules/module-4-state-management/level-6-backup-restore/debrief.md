# Debrief — the state is precious, and it has a safety net

Every `terraform apply` (and `destroy`) copies the previous state to `terraform.tfstate.backup`
before writing the new one when you use the local backend. State subcommands such as `state rm`
and `state mv` keep their own timestamped copies (`terraform.tfstate.<number>.backup`). It is a *single-step* undo: only one backup exists, and the next write replaces it.

That makes the order of operations the whole game. When you notice a state mistake:

1. **Stop.** Do not run `apply`, or you will build new random values and overwrite the backup.
2. **Copy the evidence.** `cp terraform.tfstate.backup rescue.tfstate`, then inspect it with
   `terraform state list -state=rescue.tfstate`.
3. **Restore** with a file copy (local backend) or `terraform state push` (any backend).
   `state push` refuses an older serial or a different lineage unless you pass `-force`, a deliberate
   speed bump.

Remote backends handle this differently: S3 with versioning, Terraform Cloud state versions and GCS
object versions all keep many generations, which is one reason teams use them. With a local
backend, your own habit is the protection: run `terraform state pull > backup-$(date +%F).tfstate`
before any state surgery, and commit nothing sensitive.

The same recovery works for the opposite mistake, an `apply` that destroyed things: the previous
state shows what existed, though real objects that were destroyed are of course not brought back.
