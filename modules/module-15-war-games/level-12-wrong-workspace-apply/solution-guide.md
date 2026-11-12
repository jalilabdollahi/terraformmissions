# Runbook - Harwick Stage Post Mixup

1. **Triage.** `terraform workspace show` says `staging`. `terraform state list` there shows the seed plus
   `random_id.post_key[...]` and `local_file.post_card[...]`, and the card files live under `marshals/prod/`.
   Production posts in the staging workspace.
2. **Freeze and back up.** Nobody applies anything. `cp -R terraform.tfstate.d terraform.tfstate.d.bak`.
3. **Look at prod.** `terraform workspace select prod && terraform state list` shows only `random_id.region_seed`. Note its ID;
   it has to survive.
4. **Find the root cause in code.** `locals { env = "prod" }` from hotfix HF-31. Change it to `terraform.workspace`.
5. **Move the objects between state files** (local backend, so the files are in `terraform.tfstate.d/`):
   ```bash
   terraform state mv -state=terraform.tfstate.d/staging/terraform.tfstate \
     -state-out=terraform.tfstate.d/prod/terraform.tfstate random_id.post_key random_id.post_key
   terraform state mv -state=terraform.tfstate.d/staging/terraform.tfstate \
     -state-out=terraform.tfstate.d/prod/terraform.tfstate local_file.post_card local_file.post_card
   ```
   Moving the resource name moves every instance.
6. **Verify both sides.** `terraform workspace select prod && terraform plan` and `terraform workspace select staging && terraform plan`:
   each should show no resource changes, only an output refresh (prod gains the `post_keys` output, staging loses it). Apply that in both, then plan again: "No changes". `terraform output post_keys` in prod shows the original keys.
