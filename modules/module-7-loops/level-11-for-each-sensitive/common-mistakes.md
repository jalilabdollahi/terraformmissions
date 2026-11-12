# Common mistakes

- **Removing `sensitive = true` from the variable.** The plan passes, and the PINs are now printed in
  every plan and stored in plain sight in logs. The mission needs both loop and secrecy.
- **Wrapping the whole map: `for_each = nonsensitive(var.pins)`.** It works mechanically but leaks every
  PIN into plan output; the validator checks the plan text.
- **Hard-coding the names in a new set.** The slips no longer follow var.pins when an operator is added.
- **Using `sensitive()` on the for_each expression.** That is the opposite of what is needed - it adds
  the mark rather than removing it.
