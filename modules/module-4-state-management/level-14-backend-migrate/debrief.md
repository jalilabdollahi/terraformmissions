# Debrief — moving state on purpose

Changing a backend block is a *migration*. The old location still holds the only copy of the state; the new
one is empty. Terraform therefore will not guess: after any change to the backend configuration, every
command fails until you run `terraform init` with an explicit choice.

- **`terraform init -migrate-state`** reads the state from the previously initialised backend and writes it
  to the new one, asking for confirmation (`-force-copy` answers yes). Use it when the state must *move*:
  local to S3, one bucket to another, a renamed path.
- **`terraform init -reconfigure`** only switches the pointer. Use it when the state is already at the
  new location, or when you deliberately want an empty start.

Picking the wrong flag is the classic outage: `-reconfigure` on a relocation leaves the real state behind,
the plan wants to create everything, and an impatient `apply` builds duplicates of live infrastructure.

Before migrating, copy the old state somewhere safe (`terraform state pull > before-move.tfstate`). After
migrating, confirm with `terraform state list` and a clean plan, and only then delete the old file. For team
backends also check locking: nobody else should run Terraform while the state is in transit.
