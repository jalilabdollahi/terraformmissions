# Runbook — Cedarbank Kiln Pipeline

## 1. Triage
```bash
terraform state list
terraform plan
cat ledger/handshakes.log
ls tickets/
```
Findings: `random_integer.tag["pine"]` is missing from state and no tickets exist yet (every ticket waits for ALL
kiln runs, so the failed ash run blocked them); two kiln runs are
tainted (ash by Terraform itself after the failed provisioner, pine by hand); the plan wants to replace both and
to create a fresh pine tag.

## 2. Back up
```bash
terraform state pull > before.tfstate
```

## 3. Fix the real failure (ash)
The handshake log shows ash never got an ACK. `scripts/kilns.allow` lists `K-4`; `main.tf` says `K4`.
Correct the typo. This run genuinely failed, so leave it tainted: replacement re-runs the handshake.

## 4. Re-adopt the pine tag
The number is in the controller ledger: `ledger/handshakes.log` has `lot=pine kiln=K-2 tag=nnnn ACK`. Terraform's importer for `random_integer`
wants `result,min,max`:
```hcl
import {
  to = random_integer.tag["pine"]
  id = "nnnn,1000,9999"
}
```
Without this, the plan invents a new number and the pallet labels are wrong.

## 5. Untaint the healthy run
Pine's handshake was ACKed (see the ledger); the taint came from a panic. `terraform untaint 'terraform_data.kiln_run["pine"]'`.
Once the tag is imported the trigger values match, so no replacement is needed.

## 6. Apply and verify
`terraform plan` first: expect replace kiln_run ash and create all three tickets. Apply, then confirm the plan
is clean, the ledger has `lot=ash kiln=K-4`, and the run IDs for oak and pine match what you recorded earlier.
