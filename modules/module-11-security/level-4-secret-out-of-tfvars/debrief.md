# Debrief — a secret in git is a secret forever

`terraform.tfvars` looks like configuration, so people treat it like configuration: they commit it, review it, copy it
between environments. Mixing non-secret settings and credentials in that one file is how most Terraform leaks begin.
Marking a variable `sensitive = true` hides it from plan output, but it does nothing about the file where you typed the
value.

Terraform will read a variable from several places. The `TF_VAR_<name>` environment variables are the simplest way to inject
a secret without it touching the repository: CI systems store them as masked secrets, a developer's shell can load them from
a password manager, and no file needs to be gitignored.

Two points many teams miss. First, deleting the line only stops *future* exposure; the old value remains in git history, so the
credential must be rotated. Second, a secret supplied by environment still ends up in the state file unless the
provider supports write-only or ephemeral handling, so state needs its own protection. A `.gitignore` for `*.tfvars` that
hold secrets is good hygiene — a later mission in this module covers it — but the safest secret file is the one that does not exist.
