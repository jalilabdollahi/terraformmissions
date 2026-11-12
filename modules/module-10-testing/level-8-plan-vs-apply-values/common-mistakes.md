# Common mistakes

- **Switching `ratio_label` to apply too.** The mission keeps one plan-only run to prove you picked the command per claim.
- **Dropping the regex assertion and checking only that the output is not empty.** An unknown value cannot be tested at plan time either way; the validator re-runs the suite against a code mutant that changes the code shape.
- **Hard-coding a seed or fixed value.** The `random` provider has no seed here, and the mission is about checking shape, not a particular value.
- **Using `try()` around the condition.** `try` on an unknown value does not make it known.
