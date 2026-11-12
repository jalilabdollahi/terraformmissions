# Common mistakes

- **Using `var.ticket` instead of the resource name.** Variables are rejected in destroy provisioners for
  the same reason; the value has to come from `self`.
- **Deleting the destroy provisioner.** The configuration validates, but the closing line disappears and the
  validator's replace test fails.
- **Switching to `when = create`.** The log would say 'closed' at the moment of opening: wrong, and the
  destroy path then logs nothing.
- **Adding `on_failure = continue`.** It hides errors at run time, but does not fix a reference error
  found at validation.
