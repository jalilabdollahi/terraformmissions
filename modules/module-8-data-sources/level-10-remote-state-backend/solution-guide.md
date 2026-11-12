# Walkthrough — Gritter Depot Handshake

1. **Diagnose.** `terraform plan` fails with `Unable to find remote state ... No stored state was
   found for the given workspace in the given backend.` The data source looked at
   `depot-team/terraform.tfstate`.
2. **Find the real location.** `depot-team/terraform.tf` has
   `backend "local" { path = "state/depot.tfstate" }`, and `ls -R depot-team/state` shows
   `depot.tfstate`. A consumer must use the producer's backend settings.
3. **Fix.**
   ```hcl
   config = {
     path = "${path.module}/depot-team/state/depot.tfstate"
   }
   ```
4. `terraform apply`; the header reads `Depot NGD-04: 6 bays, first gritter 05:12`. Type `check`.
