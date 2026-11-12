# Walkthrough — Vault Serial Audit

1. **List what Terraform manages.**
   ```bash
   terraform state list
   # local_file.registry
   # random_integer.serial["annex"]
   # random_integer.serial["basement"]
   # random_integer.serial["north-wing"]
   # random_pet.night_guard
   ```
2. **Show the annex vault.** Quote the whole address so the shell does not strip the inner quotes:
   ```bash
   terraform state show 'random_integer.serial["annex"]'
   # resource "random_integer" "serial" {
   #     id     = "483920"
   #     max    = 999999
   #     min    = 100000
   #     result = 483920      <- the serial (yours will differ)
   # }
   ```
3. **Show the guard.** `terraform state show random_pet.night_guard` and read the `id` line.
4. **Write the answers.**
   ```bash
   mkdir -p answers
   echo 483920 > answers/vault-serial.txt
   echo guard-able-wolf > answers/night-guard.txt
   ```
5. Type `check`. Do not run `terraform apply` with changes: nothing needs to change.
