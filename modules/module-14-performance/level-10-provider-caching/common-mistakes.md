# Common Mistakes

- **Exact version pinning with = operator** — brittle; breaks when a version is yanked from the registry.
- **Setting TF_PLUGIN_CACHE_DIR to a read-only path** — init silently bypasses cache or fails.
- **Different constraints across configs** — leads to multiple provider versions being cached unnecessarily.
- **Not committing .terraform.lock.hcl** — without the lock file, the selected version can drift between runs.