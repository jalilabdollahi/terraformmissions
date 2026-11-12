# Walkthrough — Falconry Weigh-In

1. **Diagnose.** `terraform plan` fails with
   `flying-weight.sh: query must contain bird, weight_g and target_pct (got: {})`. The script
   ran, but received an empty JSON object.
2. **Find where input comes from.** `bin/flying-weight.sh` begins with `input=$(cat)`, so it reads
   JSON from stdin. The external data source builds that JSON from its `query` argument; extra
   items in `program` are plain command-line arguments, which this script ignores.
3. **Fix.**
   ```hcl
   data "external" "flying_weight" {
     program = ["bash", "${path.module}/bin/flying-weight.sh"]

     query = {
       bird       = var.bird
       weight_g   = var.weight_g
       target_pct = var.target_pct
     }
   }
   ```
   Query values are strings; numbers are converted for you.
4. `terraform apply` -> `flying_weight_g = 959`. Type `check`.
