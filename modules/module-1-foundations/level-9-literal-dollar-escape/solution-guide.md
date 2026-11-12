# Walkthrough — Dome Three Watering

1. **Run `terraform validate`.** Typical errors:
   ```
   Error: Extra characters after interpolation expression
     on main.tf line 16, in resource "local_file" "water_script":
   Template interpolation doesn't expect a colon at this location. Did you intend this to be a
   literal sequence to be processed as part of another language? If so, you can escape it by
   starting with "$${" instead of just "${".
   ```
   Once that is fixed, `${HOME}` is reported as an invalid reference. Terraform parsed both as its own expressions.
2. **Understand.** In a string or heredoc, `${...}` always means *Terraform* interpolation. The shell syntax collides with it.
3. **Escape.** Replace `${HOME}` with `$${HOME}` and `${PUMP_SECONDS:-30}` with `$${PUMP_SECONDS:-30}`. A doubled `$` followed by `{` produces a literal `${`.
4. **Apply and read the script.** `cat dome3/water.sh` shows `${HOME}` verbatim and the bay name filled in. The plain `$PUMP_LOG` never needed escaping: it has no brace.
