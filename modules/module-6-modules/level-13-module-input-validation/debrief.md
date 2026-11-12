# Debrief — validation guards the boundary, the caller adapts

A `validation` block on a module variable is a precondition on the *interface*. Terraform evaluates it when the
module is instantiated, before any resource in it is planned, and reports the author's `error_message` at the call
site. Those messages are the module's documentation at the moment it matters, so read them like instructions.

The tempting repair is to relax the check. Resist it unless the check itself is wrong: a regex or a range encodes an
assumption the module's own code relies on, such as a printer that only fits 6-character codes, and every other caller
benefits from it. When the caller is the odd one out, convert in the caller: format the string, multiply the unit,
clamp the number with `min()` and `max()` if clamping really is the intended behaviour.

Unit mix-ups are a classic. A variable named `doors_open_hours` and another named `doors_open_min` sit one line apart
and are both "just numbers". Putting the unit in variable names, as this module does, is cheap protection; validation
turns it into a hard failure instead of a quietly wrong programme.

Finally, test the guard too. A fix that makes valid inputs pass but also lets invalid ones through is no fix. The
validator tries a two-hour opening, which must still be refused with the module's own message.

**Takeaway:** treat module validation errors as the interface contract, convert values in the caller, and keep the
checks working for other callers.
