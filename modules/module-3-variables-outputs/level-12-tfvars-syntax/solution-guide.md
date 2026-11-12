# Walkthrough — Port Calder

1. **Diagnose.** `terraform plan` fails before anything is read:
   `Error: Argument or block definition required` with `on terraform.tfvars line 2`, and the hint
   `use the equals sign "=" to introduce the argument value`.
2. **Reason.** `.tfvars` files are parsed as HCL attribute assignments: `key = value`, one per line.
   Colons are YAML/JSON syntax; Terraform has no fallback parser for them.
3. **Fix.** Edit each line to use `=`. Lists and bools keep their HCL form (`["a", "b"]`, `true`).
4. **Verify.** `terraform plan` no longer asks for variables; `terraform apply` writes `notice/pilotage.txt`.
