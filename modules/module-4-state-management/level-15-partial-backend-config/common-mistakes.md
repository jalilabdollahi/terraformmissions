# Common mistakes

- **Hard-coding `path` in terraform.tf.** It works for one station but defeats the whole point of a shared config; the validator rejects it.
- **Fixing the file and running init without `-backend-config`.** The default location stays active; Terraform does not look for the file on its own.
- **Forgetting `-reconfigure` after the first init.** Terraform says the backend configuration changed and stops.
- **Using `-migrate-state` and answering no.** Nothing moves, and the backend is not switched.
- **Applying before the init succeeds.** Resources land in the default `terraform.tfstate`, not in state/signal-tower.tfstate.
