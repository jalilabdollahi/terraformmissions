# Walkthrough — Helpline Queue Defaults

1. **Plan.**
   ```
   Error: Invalid value for input variable
   The given value is not suitable for module.routing.var.queues ...: element "night_desk": attribute "bitrate_kbps" is required.
   ```
2. **Cause.** The type is `map(object({ skill = string, bitrate_kbps = number, jingle = bool }))`. All three attributes are required.
3. **Declare the optional attributes with defaults** in the module:
   ```hcl
   bitrate_kbps = optional(number, 128)
   jingle       = optional(bool, true)
   ```
   Terraform fills the defaults when it converts the caller's value to the type; no `merge()` or `lookup()` needed.
4. Apply; check the rota file. Then `check`.
