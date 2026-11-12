# Walkthrough: Bounce Hollow Big Bang

1. **Plan and sort the output.**
   - `random_id.band[0]` ... `[2]` and `local_file.court_card[0]` ... `[2]` will be destroyed, and the same
     six keyed instances created. (count index to for_each key)
   - `random_pet.mascot will be destroyed`. (left the configuration)
   - `random_integer.highscore will be created`. (should have been adopted)
2. **Moves for the keys.** Six blocks, using the order in NOTES.md:
   ```hcl
   moved {
     from = random_id.band[0]
     to   = random_id.band["freestyle"]
   }
   # ... band[1] -> "dodgeball", band[2] -> "ninja", and the same three for local_file.court_card
   ```
3. **Forget the mascot.**
   ```hcl
   removed {
     from = random_pet.mascot
     lifecycle { destroy = false }
   }
   ```
4. **Adopt the high score.**
   ```hcl
   import {
     to = random_integer.highscore
     id = "7421,1000,9999"
   }
   ```
5. **Plan.** Expect `has moved to` six times, `will no longer be managed by Terraform, but will not be destroyed`
   for the mascot, `will be imported` for the high score and `0 to destroy`. Apply and type `check`.
