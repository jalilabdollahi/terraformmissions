# Runbook - Halcyon Stack Breakup

1. **Triage.** Read `SPLIT-PLAN.md`: three stacks, no re-issuing, remote state between them. Open each scaffold next to
   `monolith/main.tf` and list the mapping: venue gets the hall key, seat capacity, two stage serials; ticketing gets the
   booking namespace, pass series and ticket book; streaming gets `cdn_key` (now `stream_key`), the encoders and the playlist.
2. **Freeze and back up.** `cp monolith/terraform.tfstate monolith/terraform.tfstate.pre-split`. Nobody applies in
   `monolith/` any more.
3. **Move venue.**
   ```bash
   terraform state mv -state=monolith/terraform.tfstate -state-out=venue/terraform.tfstate random_id.hall_key random_id.hall_key
   # same for random_integer.seat_capacity and random_id.stage_serial (moves both instances)
   ```
4. **Publish venue outputs.** `cd venue && terraform apply`. The plan should only add outputs; resources stay as they are.
5. **Move ticketing**, add the missing `output "gold_series"` to `ticketing/main.tf`, then `terraform apply` there.
6. **Move streaming**, renaming on the way:
   `terraform state mv ... random_id.cdn_key random_id.stream_key`, plus `terraform_data.encoder` and `local_file.playlist`.
   `terraform apply` in `streaming/`.
7. **Empty the monolith.** `jq '.resources|length' monolith/terraform.tfstate` is 0; delete the resource code in
   `monolith/*.tf`.
8. **Verify.** `terraform plan` in each of the three stacks reports no changes.
