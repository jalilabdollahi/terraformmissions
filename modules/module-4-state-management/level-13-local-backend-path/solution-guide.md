# Walkthrough — Ghost Tuk-Tuk State

1. **Notice the symptom.** `terraform plan` shows `Plan: 3 to add`, and `terraform state list` is empty.
2. **Find the real state.**
   ```bash
   ls states/
   # tuktuk-prod.tfstate
   terraform state list -state=states/tuktuk-prod.tfstate
   # local_file.timetable, random_integer.departure_minute, random_pet.tuktuk_name
   ```
3. **Fix the path** in the `backend "local"` block of terraform.tf:
   ```hcl
   backend "local" {
     path = "states/tuktuk-prod.tfstate"
   }
   ```
4. **Re-initialise.** Terraform now says `Backend configuration changed`. Use:
   ```bash
   terraform init -reconfigure
   ```
   `-reconfigure` adopts the new location as-is. (`-migrate-state` would try to copy the old, empty state onto it.)
5. `terraform plan` is clean. Type `check`.
