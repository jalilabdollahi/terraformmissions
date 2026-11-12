# Walkthrough - Orienteering Cutoff Logic

1. `terraform test -verbose` fails in `default_runner` and `slow_runner`. For each failure read:
   - the `error_message` - what the author *meant*;
   - the condition and the `LHS`/`RHS` values - what it *says*.
2. `default_runner`, first assert: message says "inside the 90-minute cutoff" but the condition is
   `output.finish_minutes >= 90`. 68 is not >= 90. Use `< 90`.
3. `default_runner`, second assert: message says checkpoints must be increasing, but the condition
   checks that every checkpoint is `<` its predecessor, i.e. decreasing. Flip the comparison to `>`.
   (Do not reach for `sort()` here: it sorts numbers as strings, so 9 would sort after 16.)
4. `slow_runner`: a 9 min/km runner finishes after 111 minutes. The message says the sheet must flag a
   missed cutoff, so `output.within_cutoff` (false) is the expected value; assert `!output.within_cutoff`.
5. The fourth assert (`finish_minutes == 68`) is already right. Run again: `Success! 2 passed, 0 failed.`
