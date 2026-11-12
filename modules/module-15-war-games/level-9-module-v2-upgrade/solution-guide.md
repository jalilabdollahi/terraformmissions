# Runbook — Skerrow Roster Module v2

## 1. Triage
```bash
cat modules/roster/CHANGELOG.txt
terraform validate    # Unsupported argument "crew"; then unsupported attribute member_names
```

## 2. Back up
`terraform state pull > before-v2.tfstate`.

## 3. Fix the interface
In the root: `members = local.crew` and `module.roster.callsigns`.

## 4. Read the plan
```bash
terraform plan
```
Expected trap: 10 resources to replace (5 `random_pet.member` -> `callsign`, 5 `local_file.card` -> `duty_card`), plus five
cards that would change `shift 12h` to `shift 8h`.

## 5. Tell Terraform about the renames
A `moved` block inside the module gives every consumer the same migration. A single block per resource type covers all
instances of a `for_each`:
```hcl
moved {
  from = random_pet.member
  to   = random_pet.callsign
}
moved {
  from = local_file.card
  to   = local_file.duty_card
}
```
(`terraform state mv` ten times would work too, for this caller only.)

## 6. Pin the old behaviour until the policy takes effect
Set `shift_hours = 12` on the module call. The new default is an ordinary in-place update, so it will never appear
in a "forces replacement" scan.

## 7. Apply and verify
`terraform plan` shows only moves; apply; plan again clean; `cards/*.txt` still say `shift 12h`.
