# Walkthrough — Cave Survey Probes

`terraform plan` reports three separate failures from `data.external.*`:

1. **bore** — `no such file or directory` for `.../scripts/bore-depth.sh`. `ls` shows the scripts
   live in `probes/`. Fix the path: `["bash", "${path.module}/probes/bore-depth.sh"]`.
2. **air** — `permission denied` when Terraform tries to execute `probes/air-quality.py` directly.
   The file has no execute bit (`ls -l probes`). Either `chmod +x probes/air-quality.py` or run it
   through the interpreter: `["python3", "${path.module}/probes/air-quality.py"]`.
3. **damp** — Python reports a syntax error: `humidity.sh` is a bash script but `program` starts it
   with `python3`. Use `["bash", "${path.module}/probes/humidity.sh"]`.

Then `terraform apply`; `terraform output` shows `depth_m = 84`, `o2_pct = 19.6`, `humidity_pct = 97`.
Type `check`.
