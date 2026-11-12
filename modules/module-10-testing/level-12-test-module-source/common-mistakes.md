# Common mistakes

- **Using an absolute path or `${path.module}`.** Source must be a static string; expressions are not allowed in a run's module block.
- **Deleting the two module runs.** The root run alone would not prove the helpers right; the validator requires both and mutates the helper modules.
- **Writing `modules/block` without `./`.** Terraform reads it as a registry source and fails with "Invalid module source address".
- **Forgetting `terraform init` after the edit.** The error becomes "Module not installed", even with the right path.
