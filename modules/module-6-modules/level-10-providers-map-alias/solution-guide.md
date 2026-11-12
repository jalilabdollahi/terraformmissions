# Walkthrough — Wexcombe Offsite Ledger

1. **Read the error.** `terraform init` / `plan` reports that module.ledger requires the provider configuration
   `local.mirror` and that it was not passed. The module's header shows why:
   `configuration_aliases = [local.mirror]`.
2. **Understand the direction.** A module's alias name (`local.mirror`) is a placeholder. The root decides which of
   *its* configurations fills it: here `local.offsite`.
3. **Add the providers map to the call.**
   ```hcl
   providers = {
     local        = local
     local.mirror = local.offsite
   }
   ```
4. `terraform apply`. Check with `terraform state pull | jq '.resources[] | {name, provider}'`: the mirror resource shows
   the `offsite` alias. Then `check`.
