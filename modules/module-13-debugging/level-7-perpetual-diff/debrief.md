# Debrief - plans must be pure

A configuration is stable when evaluating it twice against the same state gives the same answer. Anything that changes
between two plans leaves a permanent diff, and a permanent diff is dangerous: people stop reading plans, CI stops
being a signal and the one real change is buried in noise.

The usual suspects are:

- **Functions that read the clock or randomness during planning**: `timestamp()` and `uuid()`. Use `time_static` (stored
  once), `random_uuid` (stored once) or pass the value in as a variable if you want it controlled by the caller.
- **Unordered data**: sets, `data` sources or scripts that return items in arbitrary order. Terraform's own collections are
  predictable (maps sort their keys, `toset` sorts its elements), but text that comes from outside is not; apply `sort()` before
  you render it.
- **Provider normalisation** (the API returns a different spelling than you wrote), the realm of `lifecycle.ignore_changes`.

The tempting fix, `ignore_changes = [content]`, suppresses the symptom and also all *legitimate* updates, so the file would never
change again when the entries do. Find the unstable input and remove it. When you cannot control a provider's normalisation,
`ignore_changes` is acceptable, but only for that one attribute and with a comment explaining why.
