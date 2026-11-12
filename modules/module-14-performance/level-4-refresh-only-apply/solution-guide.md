# Walkthrough — Geyser Feed Reconcile

1. **Plan.** `terraform plan` prints
   `Changes to Outputs: ~ latest_height_m = 3.2 -> 11.8` and also
   `# local_file.park_banner must be replaced` (the colleague's edit).
2. **Separate the two.** The first is the world moving on (feed file), the second is unreviewed code.
   `terraform plan -refresh-only` shows only the first.
3. **Accept the first, skip the second.**
   ```bash
   terraform apply -refresh-only
   ```
   Approve. State now records 11.8 m at 09:30; no resource is created, changed or destroyed.
4. **Check.** `terraform plan -refresh-only` is clean; `terraform plan` still shows the banner change,
   as it should until someone reviews it. A normal `terraform apply` would have replaced banner.txt too.
