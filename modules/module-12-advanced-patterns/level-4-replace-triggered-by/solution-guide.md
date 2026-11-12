# Walkthrough: Reflash On Release

1. **Plan before changing anything.**
   ```
   # terraform_data.firmware_pack will be updated in-place
   ~ input = "3.1" -> "3.2"
   ```
   The cabinet is missing from the plan, even though the release is meant to rebuild it.
2. **Read the lifecycle block of the cabinet.** It says
   `replace_triggered_by = [terraform_data.calibration]`. Calibration did not change, so nothing triggers.
3. **Watch the right resource.**
   ```hcl
   replace_triggered_by = [terraform_data.firmware_pack]
   ```
4. **Plan again.** It now says `terraform_data.cabinet will be replaced due to changes in
   terraform_data.firmware_pack`, and the service card is rewritten because the cabinet ID changes.
   Apply and type `check`.
