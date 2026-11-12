# Common mistakes

- **Moving the rules into a `precondition`.** A precondition cannot use `self` and would still need to name
  the resource; it checks inputs, not results.
- **Pointing the rules at the label file.** That makes the batch record depend on the label, which depends on
  the batch, a real cycle.
- **Deleting the postconditions.** The configuration validates, but the 5-litre and 5-day rules are the whole point.
- **Using `self.input` instead of `self.output`.** It works for terraform_data, but output is the value
  that has been through apply, which is what a postcondition is for.
