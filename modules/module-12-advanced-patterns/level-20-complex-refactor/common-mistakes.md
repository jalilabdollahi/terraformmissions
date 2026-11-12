# Common mistakes

- **Applying first and fixing later.** The tokens printed on the cabinet stickers are regenerated and the mascot
  is destroyed; there is no way back to the old random values.
- **Moving `[0]` to `["0"]`.** The new keys are the cabinet names, in the order given in NOTES.md; a numeric key would be
  a different instance.
- **Forgetting the cards.** The tokens move but the card files are still planned for replacement: both resources
  need their three moved blocks.
- **Using `destroy = true` (or no lifecycle) on the mascot.** The mascot is destroyed; the mission says to forget it.
- **Putting the jackpot in with a hard-coded `result`.** `random_integer` has no argument for the result; only
  an import can carry 7421 over.
