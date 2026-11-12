# Walkthrough — Neon Rift laser tag arena

1. **Diagnose syntax.** `jq . terraform.tfvars.json` fails near the end of the file (a trailing comma after `"site": ...`).
   Terraform reports it as `Error: Root value must be object` on `terraform.tfvars.json`.
2. **Fix it.** Delete the comma after the last property.
3. **Diagnose shape.** Run `terraform plan` again. Now the error is
   `Invalid value for input variable ... The given value is not suitable for var.site: object required.`
   The JSON gives `site` as the string `"36.2,-118.9"`.
4. **Fix it.** Write the object the variable expects: `"site": { "lat": 36.2, "lon": -118.9 }`.
5. **Verify.** `terraform apply` and `terraform output arena_latitude` → `36.2`.
