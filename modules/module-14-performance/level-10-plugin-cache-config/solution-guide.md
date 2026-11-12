# Walkthrough — Render Farm Plugin Shelf

1. **Read the evidence.** Run `TF_CLI_CONFIG_FILE=ci/terraform.rc terraform init` in an empty directory
   and look for `Installing hashicorp/...` and an empty `~/.terraform.d/plugin-cache`. With a cache in
   use, `ls -l .terraform/providers/.../` shows a symlink into the cache directory.
2. **Fix the path.** CLI configuration files expand `$HOME` (environment variables) but not `~`. Change the
   setting to `plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"`.
3. **Make the directory exist.** Terraform does not create `plugin_cache_dir`; if it is missing it is
   ignored. `ci/agent-setup.sh` must create the same path:
   `mkdir -p "$HOME/.terraform.d/plugin-cache"`.
4. **Disable the version check.** `disable_checkpoint = true`, so agents do not make outbound
   calls.
5. **Verify.** Initialise two separate empty directories with this config; in both, the provider
   directories are symlinks into the cache, and the second init does not download anything.
