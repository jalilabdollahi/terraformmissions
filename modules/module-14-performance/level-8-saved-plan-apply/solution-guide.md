# Walkthrough — Tree Order Approval Plan

1. **Reproduce.** `terraform apply plan.tfplan` fails with
   `Error: Saved plan is stale — The given plan file can no longer be applied because the state was
   changed by another operation after the plan was created.`
2. **See the current gap.** `terraform plan` shows `Plan: 2 to add` — t-3011/12 and t-3013 exist
   already; t-3014 and t-3015 are still missing (one order was applied by hand).
3. **Make a new reviewed plan.**
   ```bash
   terraform plan -out=plan.tfplan
   terraform show plan.tfplan        # human review; or `terraform show -json plan.tfplan | jq`
   ```
   This overwrites the stale file with a plan that matches today's state.
4. **Apply that exact plan.**
   ```bash
   terraform apply plan.tfplan
   ```
   No confirmation prompt appears because the plan file is the approval.
5. **Check.** `terraform plan` reports *No changes*.
