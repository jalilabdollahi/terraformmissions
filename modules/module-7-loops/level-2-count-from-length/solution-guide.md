# Walkthrough - Five Dogs Three Charts

1. `terraform apply` succeeds, which is what makes this bug nasty. `terraform state list` shows
   `local_file.feeding_chart[0]` to `[2]` only, and `ls charts/` shows three files.
2. The output `chart_total` says 3 although `var.dogs` has five names.
3. Replace the literal with the length of the list:
   ```hcl
   count = length(var.dogs)
   ```
4. Apply. Charts for Sitka and Nome appear, `chart_total` is 5 and the plan is clean. Try
   `terraform plan -var 'dogs=["Tundra"]'` to see four charts scheduled for deletion - the count now
   follows the data in both directions.
