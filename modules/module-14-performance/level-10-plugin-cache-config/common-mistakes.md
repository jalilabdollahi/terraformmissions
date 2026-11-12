# Common mistakes

- **Writing `~/.terraform.d/plugin-cache`.** The tilde is passed to the filesystem literally; Terraform
  makes no use of it, and the cache stays empty.
- **Fixing the config but not agent-setup.sh.** Terraform ignores a plugin cache directory that does not
  exist, so the setting silently does nothing.
- **Pointing the cache inside the project (`.terraform/cache`).** It then dies with each workspace, so
  nothing is shared between jobs.
- **Using an absolute path like /var/cache/terraform.** Unprivileged agent users cannot create it;
  keep the cache under `$HOME`.
