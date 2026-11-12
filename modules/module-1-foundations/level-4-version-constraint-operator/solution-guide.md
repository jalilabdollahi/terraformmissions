# Walkthrough — Fete Tombola Draw

1. **Run `terraform init`.** Output:
   ```
   Error: Invalid version constraint
     on terraform.tf line 6, in terraform:
      6:       version = "=> 3.6"
   This string does not use correct version constraint syntax.
   ```
   A second error points at the `~>=` constraint on the local provider.
2. **Check the operator list.** Terraform understands `=`, `!=`, `>`, `>=`, `<`, `<=`, `~>`.
   `=>` is the arrow people write from muscle memory (JavaScript, Ruby); in Terraform the
   comparison is `>=`. `~>=` glues two operators together.
3. **Fix both** — `">= 3.6"` and `"~> 2.5"` (or any other valid constraint the cached versions satisfy).
4. **Run `terraform init` and `terraform apply`.**
