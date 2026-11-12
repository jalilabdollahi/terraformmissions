# Walkthrough — Route Chart First

1. **See the blocker.** `terraform plan` ends with `Resource precondition failed ... Weighbridge ticket missing`.
   A normal apply cannot proceed.
2. **Target the chart.**
   ```bash
   terraform apply -target=local_file.route_chart
   # Warning: Resource targeting is in effect
   # Plan: 2 to add, 0 to change, 0 to destroy.
   ```
   Two resources, not one: `local_file.route_chart` references `random_id.route_code`, so Terraform includes that dependency.
3. **Verify.**
   ```bash
   terraform state list
   # local_file.route_chart
   # random_id.route_code
   ```
   `random_pet.driver` is not there: it does not depend on the chart.
4. Type `check`. Do not edit the precondition to make the full plan pass.
