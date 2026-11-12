# Walkthrough — Alder Hollow Seed Vault

1. **Run `terraform init`.** The first error:
   ```
   Error: Unsupported argument
     on terraform.tf line 4, in terraform:
      4:   required_providers = {
   An argument named "required_providers" is not expected here. Did you mean to define a block of type "required_providers"?
   ```
   After fixing it, `terraform validate` reports the same kind of error for `lifecycle` in `main.tf`.
2. **Blocks have no `=`.** `required_providers { ... }` and `lifecycle { ... }` are nested blocks.
   Attributes inside them keep their `=`.
3. **Fix both places.**
4. **Verify the behaviour.** Apply, then `terraform plan -var 'inspector=Someone Else'` should say *No changes*.
