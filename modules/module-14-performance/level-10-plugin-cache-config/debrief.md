# Debrief — one download per agent, not one per directory

Every `terraform init` installs providers into the working directory's `.terraform/`. Providers
are tens of megabytes each, so a CI farm with many jobs, workspaces or monorepo components downloads
the same binaries over and over. A **plugin cache** is a shared directory: Terraform installs
there once and links (symlinks, where the OS allows) the binary into each `.terraform/` folder.

The mechanics are small and unforgiving:

- The setting lives in the **CLI configuration** (`plugin_cache_dir`) or in `TF_PLUGIN_CACHE_DIR`.
  It is not part of your `.tf` files, which is why it can be forgotten.
- Terraform expands environment variables such as `$HOME` but not `~`.
- The directory must already exist. If it does not, Terraform carries on without a cache and says
  little, which is why the bug survives for months.
- The cache is not concurrency-safe on every platform and is never cleaned up. Treat it as
  per-agent (or per-runner), keep it under a path that survives between jobs, and prune old versions.
- The `.terraform.lock.hcl` file still decides *which* version and hashes are acceptable; the cache is
  only where bytes come from.

Related speed-ups are `disable_checkpoint` (no calls home), `TF_IN_AUTOMATION`, and a provider
mirror inside your network.

Real-world takeaway: verify that a performance setting is actually in effect by looking for its
effect (symlinks in `.terraform/providers`), not by trusting that the config file exists.
