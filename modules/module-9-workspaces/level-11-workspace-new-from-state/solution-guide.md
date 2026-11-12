# Solution guide

**Diagnose.** `terraform workspace list` shows only `default`, whose state is empty. `snapshots/jam-ledger.tfstate`
holds the real codename (open it, or `jq .outputs snapshots/jam-ledger.tfstate`).

**Fix.**

```
terraform workspace new -state=snapshots/jam-ledger.tfstate rehearsal
terraform plan
```

`-state` copies the file into `terraform.tfstate.d/rehearsal/terraform.tfstate` and selects the new
workspace. The plan is clean because the state matches the configuration and the card on disk.
