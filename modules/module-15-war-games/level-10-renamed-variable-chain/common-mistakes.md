# Common mistakes

- **Stopping when `validate` goes green.** The chain is wired, but the value is not; the plan replaces the beacon and
  the channel as soon as someone applies.
- **Changing the default `UNSET` to the real identity.** It hides the tfvars mismatch, the plan is clean, and
  the next environment that relies on tfvars again gets a placeholder.
- **Keeping the old variable name "for compatibility" in one layer.** The chain works today and reintroduces the
  exact inconsistency that caused the incident the next time someone renames it.
- **Hard-coding `"MR-ALPINE-7"` in the module calls.** It bypasses the variable chain completely and breaks the
  station's other deployments.
- **Importing or `state mv`-ing the replaced objects after an accidental apply.** Their new serials are already
  broadcast; the field radios have to be reprogrammed regardless.
