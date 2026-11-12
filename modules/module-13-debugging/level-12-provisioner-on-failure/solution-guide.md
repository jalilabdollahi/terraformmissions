# Walkthrough - Silent Cleaning Failure

1. The log file is missing although `terraform apply` succeeded. Look for the setting that makes that possible:
   `grep -n on_failure main.tf` finds `on_failure = continue`.
2. Make the failure visible: temporarily run `bash scripts/clean.sh batch-114 20C` by hand. It prints
   `clean: wash temperature must be a whole number of degrees, got '20C'` and exits 2.
3. Fix both things in `main.tf`: delete the `on_failure` line, and pass `${var.wash_temp_c}` without the `C`.
4. A plain `terraform apply` now says "No changes": the resource exists and nothing about it changed, so the provisioner does not run.
   Force a new creation:
   ```bash
   terraform apply -replace=terraform_data.clean_batch
   ```
5. `plant/batch-114.log` exists; `terraform plan` is clean. `check`.
