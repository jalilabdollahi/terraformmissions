# Walkthrough — Aurelia Opera House

1. **Diagnose.** `terraform plan` fails with `Invalid value for variable ... Ticket codes look like ORC-2041 ...`.
   Even the default fails, which tells you the *condition* is the wrong thing, not the value.
2. **Test the regex by hand.** `terraform console` and try
   `can(regex("^[A-Z]{3}[0-9]{4}$", "ORC-2041"))` → `false`.
3. **Spot the gap.** The regex has no `-` between the letters and the digits. As written it would only
   accept `ORC2041`.
4. **Fix.** `regex("^[A-Z]{3}-[0-9]{4}$", var.ticket_code)`. Keep the anchors.
5. **Verify.** The default passes. In `terraform console`, `can(regex(..., "orc-2041"))` is `false`.
