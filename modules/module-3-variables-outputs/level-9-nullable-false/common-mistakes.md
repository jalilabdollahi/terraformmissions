# Common mistakes

- **Giving the root variable `default = 30`.** Works today, but then the number lives in two places and
  the module's own default is dead code — the mission wants the module to own it.
- **Wrapping the call in `coalesce(var.retention_override, 30)`.** Same duplication; the validator looks
  for the fix in the module.
- **Removing `retention_days` from the module call.** The override can no longer reach the vault, and
  `-var retention_override=7` stops having any effect.
- **Setting `nullable = false` on the root variable.** That would reject the default `null` itself and the
  plan fails earlier with a different message.
