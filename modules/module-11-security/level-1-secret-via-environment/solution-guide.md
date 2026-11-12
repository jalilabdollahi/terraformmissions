# Walkthrough — Whisper Down The Cable

1. **Find the leak.** In `main.tf` the provisioner's `command` interpolates `${var.landing_password}`.
   The command line of the child process is world-readable (`ps aux`, `/proc/<pid>/cmdline`), so any other user on the
   build host can read it while the script runs.
2. **Check what the script saw.** After an apply, `logs/handshake.log` has an `argv:` line that contains the
   password. The `env_digest:` line shows the script got nothing in `LANDING_PASSWORD`.
3. **Fix.** Drop `--password ...` from `command` and use the `environment` argument:
   ```hcl
   provisioner "local-exec" {
     command = "bash ${path.module}/bin/handshake.sh --site ${var.site}"
     environment = {
       LANDING_PASSWORD = var.landing_password
     }
   }
   ```
4. Because `triggers_replace` did not change, force the provisioner to run again with
   `terraform apply -replace=terraform_data.handshake` when you test by hand, then type `check`.
