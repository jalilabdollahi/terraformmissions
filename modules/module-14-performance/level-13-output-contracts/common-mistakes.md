# Common mistakes

- **Editing rigging.tf to use the new output.** That works today but is another team's file; the
  contract's point is that old consumers keep working during the transition.
- **Keeping `power_kw` without a `deprecated` message.** Nobody learns that it will go away, so it never
  does.
- **Hard-coding `"2.1"` inside the contract.** The version should be one variable, so a bump reaches the
  consumers; the validator bumps it to 3.0 and expects lighting to refuse.
- **Adding the precondition to the module instead of lighting.** The producer cannot know what versions its
  consumers support; the guard belongs to the consumer.
- **Returning the contract as separate outputs.** Consumers then cannot read the version and the values
  together as one unit.
