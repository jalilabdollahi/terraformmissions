# Runbook — Meridian Dish Blackout

## 1. Triage
```bash
terraform state list          # Error: Failed to load state: ... unexpected end of JSON input
ls -la terraform.tfstate*     # a short terraform.tfstate and an older .backup
```
Do NOT run `rm terraform.tfstate && terraform apply`. Four random serials would be regenerated.

## 2. Preserve evidence
```bash
cp terraform.tfstate terraform.tfstate.corrupt
cp terraform.tfstate.backup terraform.tfstate.backup.keep
```
Terraform overwrites `.backup` on every state write, so keep a copy before the next command.

## 3. Restore the last good copy
```bash
cp terraform.tfstate.backup terraform.tfstate
terraform state list   # north, south, east only - the west dish is missing
terraform plan         # wants to CREATE random_id.receiver["west"] with a new value
```
A backup is only as new as the apply that preceded it. This one predates the west dish.

## 4. Re-adopt the object the backup does not know
The west serial survived on disk in `calibration/dish-west.cfg` (`receiver_serial = RX-<value>`).
`random_id` is importable by its base64url value:
```bash
terraform import 'random_id.receiver["west"]' <value-without-RX->
```
Single quotes keep the shell from eating the double quotes in the key.

## 5. Converge
`terraform plan` should now show only in-place updates (the north retune and the roster file).
Apply, then verify `terraform plan` -> No changes and that `terraform output array_serials` shows the same
west serial as the file.
