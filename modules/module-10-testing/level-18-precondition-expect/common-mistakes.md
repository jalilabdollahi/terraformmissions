# Common mistakes

- **Deleting `too_heavy` or `too_tall`.** The validator requires both and removes each precondition in a copy to see that the matching run fails.
- **Expecting `var.shell_kg`.** The variable has no validation block; the failing object is the permit resource.
- **Overriding both height and weight in one run.** The run still passes, but the validator requires that each negative run violates only its own rule.
- **Loosening the preconditions in `permit.tf`.** Then there is nothing left to fail and the mutants slip through.
