# Walkthrough — Freezer Audit Shortcut

1. **Compare the modes.** `ops/plan.sh quick; echo $?` and `ops/plan.sh audit; echo $?` both print
   "No changes" and exit 0, even though `freezer/ice-core-b.txt` is gone.
2. **Spot the copy-paste.** In `ops/plan.sh` both branches run
   `terraform plan -refresh=false -input=false -detailed-exitcode`.
3. **Fix only the audit branch.**
   ```bash
   audit)
     terraform plan -input=false -detailed-exitcode
     ;;
   ```
   Without `-refresh=false` the plan starts with `local_file.freezer["ice-core-b"]: Refreshing state...`,
   notices the file is gone, and exits 2 with `# local_file.freezer["ice-core-b"] will be created`.
4. **Leave quick alone.** The fast loop should keep trusting state while you edit code.
   Do not apply: the audit's job is only to report.
