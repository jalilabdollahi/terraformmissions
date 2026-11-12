# Walkthrough — Grain Co-op Triage

1. **Diagnose.** `terraform plan` shows:
   - `random_pet.harvester will be destroyed` and `random_pet.combine_operator will be created`: a rename
   - `random_integer.silo_number will be created`: lost from state (check `terraform state list`)
   - `local_file.retired_gauge_log will be destroyed`: removed from code, but the file must stay
2. **Rename in state.**
   ```bash
   terraform state mv random_pet.harvester random_pet.combine_operator
   ```
3. **Re-adopt the silo number.** The nameplate (`cat plates/silo-plate.txt`) gives the number; the pool is 100 to 999:
   ```bash
   terraform import random_integer.silo_number "412,100,999"     # use your own number
   ```
4. **Forget the gauge log.**
   ```bash
   terraform state rm local_file.retired_gauge_log
   ```
5. **Verify.** `terraform plan` says `No changes`; `ls gauges/` still shows the log. Type `check`.

Work in this order and re-plan between steps so you always know which problem is left.
