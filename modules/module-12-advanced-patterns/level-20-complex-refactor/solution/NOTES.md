# Bounce Hollow refactor: the three jobs

1. Court wristbands and cards were `count`-indexed. They are now keyed by court name with
   `for_each` (old order: freestyle = 0, dodgeball = 1, ninja = 2). The existing wristband codes are on the
   booking slips and must not change.
2. The kangaroo mascot's name (`random_pet.mascot`) is no longer managed by this configuration.
   The costume is printed already: stop managing it, but never destroy it.
3. The scoreboard sign shows high score 7421 (range 1000..9999). Bring it under management as
   `random_integer.highscore` instead of generating a new number.

Success means: no object is destroyed or replaced, and the plan is clean afterwards.
