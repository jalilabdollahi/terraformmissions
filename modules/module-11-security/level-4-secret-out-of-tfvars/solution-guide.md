# Walkthrough — Box Office Keys In Git

1. `cat terraform.tfvars` — the third line is the real gateway key. Anything committed there lives in git history forever,
   in every clone, and in every CI log that prints the file.
2. Delete the `gateway_api_key = ...` line (leave `band_name` and `ticket_price_pence`). Do not move it to a `default` in `main.tf`,
   which is the same leak in a different file.
3. Provide the value at run time:
   ```bash
   export TF_VAR_gateway_api_key='demo-not-a-real-secret-brass-9090'
   terraform apply
   ```
   Without it Terraform now stops with *No value for required variable*, which is exactly what you want.
4. Type `check`. The validator sets its own `TF_VAR_gateway_api_key` and expects it in `box-office/gateway.env`.
5. Because the old key was committed, treat it as burned and rotate it at the gateway as well.
