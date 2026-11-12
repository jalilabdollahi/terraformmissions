# Walkthrough — Stockroom Cull

1. **See what is left.** `terraform state list` prints only `random_id.rack_seal`.
2. **See what Terraform wants.** `terraform plan` ends with `Plan: 3 to add, 0 to change, 0 to destroy.`
   (register, roster, notice). The seal is not in the plan: it was never a dependent of the target.
3. **Recover.** Apply the whole configuration, with no `-target`:
   ```bash
   terraform apply
   ```
   Targeting again would only rebuild part of the graph and leave the plan unclean.
4. **Check.** `terraform plan` says *No changes*. `stockroom/notices.log` now has two lines: the
   original creation and the recreation. Replaying with `-replace` would add a third.
