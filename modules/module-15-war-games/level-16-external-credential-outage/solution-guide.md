# Runbook - Brannock Quota Blackout

1. **Triage.** `terraform plan` ends with `External Program Execution Failed` and
   `quota registry refused the request (code 43); details in logs/quota-lookup.log`. Read the log:
   `tail logs/quota-lookup.log` -> `REFUSED code=43 token from .credentials/quota-token expired on 20230630`.
2. **Read the hand-off.** `handoff/rotation-ticket.txt`: new token for service `quota-registry`, delivered via env var or
   `.credentials/quota-token`, mode 600, never in `.tf`.
3. **Install the right credential.** `jq -r '.services["quota-registry"].token' handoff/vault-export.json > .credentials/quota-token`
   then `chmod 600 .credentials/quota-token`. Not the sandbox token (code 44).
4. **Plan again.** New refusal: `code=45 unknown region 'north_sea'; the registry serves: north-sea, ...`. The variable default
   in `main.tf` has an underscore; set it to `north-sea` (the pipeline had been run with `-var region=north-sea`).
5. **Check what the failed night left.** `terraform plan` now plans one replacement: `terraform_data.permit_stamp` is tainted,
   and `out/permit-stamp.txt` says `STAMP INCOMPLETE`. That replacement is correct. The vessel key is untouched.
6. **Apply** and verify: the plan after is clean, `out/permit-stamp.txt` says `STAMPED vessel BRK-114 Marguerite ...`, and the
   log ends with `stamp ok`.
