# Common mistakes

- **Applying first and fixing later.** The wristband codes printed on the booking slips are regenerated and the mascot
  is destroyed; there is no way back to the old random values.
- **Moving `[0]` to `["0"]`.** The new keys are the court names, in the order given in NOTES.md; a numeric key would be
  a different instance.
- **Forgetting the cards.** The wristbands move but the card files are still planned for replacement: both resources
  need their three moved blocks.
- **Using `destroy = true` (or no lifecycle) on the mascot.** The mascot is destroyed; the mission says to forget it.
- **Putting the high score in with a hard-coded `result`.** `random_integer` has no argument for the result; only
  an import can carry 7421 over.
