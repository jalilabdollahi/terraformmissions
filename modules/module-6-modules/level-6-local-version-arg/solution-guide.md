# Walkthrough — Paper Crane Pattern Book

1. **Run init.**
   ```
   Error: Invalid registry module source address
   Failed to parse module registry address: can't use local directory "./modules/folds" as a module registry address.
   Terraform assumed that you intended a module registry source address because you also set the argument "version"...
   ```
   Terraform switched to registry mode because of the `version` argument, and a local path is not a registry address.
2. **Understand why.** Versions come from a registry's list of releases. A local directory has no releases, only
   whatever files are there now.
3. **Remove the argument** from `module "pattern"`. If you ever need a pinned shared pattern, publish the module
   (registry or Git tag) and pin it there.
4. `terraform init && terraform apply`; the crane has 6 steps. Then `check`.
