# Common Mistakes

- **Editing lock files manually** — never edit `.terraform.lock.hcl` by hand; let Terraform manage it.
- **Not committing the lock file** — commit it so all team members use the same provider version.
- **Using `-upgrade` carelessly** — `-upgrade` allows version upgrades; omit it to strictly use the locked version.