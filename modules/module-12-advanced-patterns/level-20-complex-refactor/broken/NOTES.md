# Pier Pavilion refactor: the three jobs

1. Cabinet tokens and cards were `count`-indexed. They are now keyed by cabinet name with
   `for_each` (old order: skee-ball = 0, claw = 1, racer = 2). The existing tokens are on the
   cabinets' stickers and must not change.
2. The gull mascot's name (`random_pet.mascot`) is no longer managed by this configuration.
   The costume is printed already: stop managing it, but never destroy it.
3. The prize-board sign shows jackpot 7421 (range 1000..9999). Bring it under management as
   `random_integer.jackpot` instead of generating a new number.

Success means: no object is destroyed or replaced, and the plan is clean afterwards.
