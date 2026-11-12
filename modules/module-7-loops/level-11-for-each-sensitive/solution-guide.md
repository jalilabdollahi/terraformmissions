# Walkthrough - Secret Keys

1. `terraform plan` fails: *Invalid for_each argument ... var.pins has a sensitive value ... cannot be used
   as for_each arguments*.
2. Don't make the secrets public. Split the map: the **keys** are operator names (not secret), the
   **values** are PINs (secret). Extract the keys and tell Terraform you know they are safe:
   ```hcl
   for_each = nonsensitive(toset(keys(var.pins)))
   content  = var.pins[each.key]
   ```
3. The PIN is still read through the sensitive variable, so it remains hidden in plan output.
4. Apply. Three slips exist, addressed `local_sensitive_file.pin_slip["vesna"]` etc., and no PIN appears
   in the plan.
