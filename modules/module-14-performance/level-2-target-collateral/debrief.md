# Debrief — -target is a scalpel with a wide blade

`-target` limits an operation to one resource **and everything it depends on** (for apply) or
**everything that depends on it** (for destroy). That is not a bug: destroying the register while the
roster still quotes its hash would leave a dangling reference. So Terraform takes the dependents down
first, in reverse order, and runs their destroy provisioners if any.

Terraform prints a warning for every targeted run because the result is a state that does not match
the configuration. The recovery is boring on purpose: the config is still the truth, so apply it
without targets. Resources that were never downstream of the target (here the rack seal) keep their
IDs and values; recreated ones get fresh IDs and re-run their create-time provisioners. That is why
notices.log grew by exactly one line.

Practical rules for teams:

- Read the destroy plan before confirming. If it shows more than the object you meant, stop.
- Treat `-target` as an emergency tool. Routine use means the configuration should be split into
  smaller state files (see the partition levels in this module).
- Never run targeted operations from CI; a saved, full plan is the reviewable artifact.
- When something has been removed that should not have been, plain `terraform apply` converges the
  real world back onto the code, as long as the state still records what survived.
