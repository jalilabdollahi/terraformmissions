# Debrief — a state file is only as good as the pointer to it

Terraform has no magic memory of your infrastructure: it has the state the *backend* hands it. With the
local backend that is one file, named by `path` (default `terraform.tfstate`). Point the backend
somewhere else and you are looking at a different, empty state. The plan then shows everything as "to
create", the most alarming plan you will see, and applying it would build duplicates of live things.

Two things to remember:

1. **Changing the backend block is not enough.** Terraform caches the initialised backend in
   `.terraform/terraform.tfstate`. When the configuration and the cache disagree, you must run
   `terraform init` with a flag that says what to do about existing state.
2. **`-reconfigure` versus `-migrate-state`.** Use `-reconfigure` when the state already sits at the new
   location (as here): it just switches. Use `-migrate-state` when the state is at the old location and you
   want it copied to the new one (the next mission).

When a plan suddenly wants to create everything, do not apply. First ask: which backend am I using, and which
state does it read? `terraform state list` returning nothing is the tell-tale. Remote backends (S3, GCS,
Terraform Cloud) have the same problem with bucket, key and workspace names, so the same questions apply.
