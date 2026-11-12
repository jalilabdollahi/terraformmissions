# Debrief — module variables are a contract

A child module's `variable` blocks are its public signature. A variable with no `default` is a required
parameter: Terraform refuses to plan until every caller supplies it, and the error points at the *call site*
("Missing required argument ... in module \"lockgate\""), not at the module's own file. That error is a gift.
It is the cheapest possible way to learn that a caller and a module drifted apart.

It is tempting to silence the error by adding a default to the variable. Do that only when the default is a
genuinely sensible answer for most callers. Here a default beam width would not be wrong loudly; it would be
wrong quietly, producing a believable toll for a boat that is nothing like the assumed one. Required inputs
are the right tool for values where "unknown" must never be turned into "average".

Also notice the mission's second half: the validator ran the plan again with different root variables. A
module call that "works" with the defaults can still be wired incorrectly. Whenever you fix a missing
argument, wire it to the real source of the value (a variable, a resource attribute, another module's
output) instead of a literal, and then change that source to prove the wire is live.

**Takeaway:** treat required module inputs as a checklist for the caller, fix the call, not the contract, and
verify with a second set of inputs.
