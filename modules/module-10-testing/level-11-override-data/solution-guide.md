# Walkthrough - Kite Festival Wind Check

1. `terraform test -verbose` shows two failures.
   - `calm_morning`: `Invalid function argument ... while calling tonumber(v) ... data.local_file.anemometer.content
     is "7dgz82iu"`. The override exists but its key is `contents`, which `local_file` does not have. Terraform
     ignores it and supplies a random string for the computed `content`.
   - `gale_warning`: `Read local file data source error ... no such file or directory`. This run has no
     override at all, so the data source is read for real and the sensor file is not on your laptop.
2. Fix 1: in `calm_morning` change `contents` to `content`.
3. Fix 2: add to `gale_warning`
   ```hcl
   override_data {
     target = data.local_file.anemometer
     values = { content = "34" }
   }
   ```
4. `gusty_edge` is already correct and shows the pattern. Run: `Success! 3 passed, 0 failed.`
5. Not the fix: creating `sensor/wind-knots.txt` yourself. That tests the real file reader instead of the logic.
