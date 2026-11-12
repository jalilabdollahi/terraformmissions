# Common mistakes

- **Changing `count = 3` to `count = 5`.** Today's chart count is right, but the next new dog brings the
  same bug back. The validator plans with seven and two dogs.
- **Using `length(local.dog_slugs)` and then editing the locals by hand.** Fine for the count, but the
  slug list must still be derived from var.dogs, not copied.
- **Replacing `count` with one `local_file` per dog.** It hides the problem by hard-coding the roster
  in a third place.
- **Setting `count = var.ration_kg`.** The wrong variable entirely - ration is a weight, not a head count.
