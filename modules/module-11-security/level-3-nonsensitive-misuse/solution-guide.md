# Walkthrough — Frost Alarm Sunshine

1. Run `TF_VAR_alarm_code=demo-not-a-real-secret-847261 terraform plan`. The `local_file` content is displayed in full
   and the `alarm_code` output is a plain string — the code is exposed.
2. In `main.tf`, `local.alarm_code_plain = nonsensitive(var.alarm_code)` removes the sensitive mark from the secret
   itself, so every consumer (file content, output) becomes visible.
3. Keep the mark on the secret and unmask only what is truly harmless:
   `alarm_code_length = nonsensitive(length(var.alarm_code))` — the length is public information.
4. Rewrite the panel text to say `Code length: N characters`, point `output "alarm_code"` at `var.alarm_code` with
   `sensitive = true`, and point `code_length` at the new local. Apply and type `check`.
