# Common mistakes

- **Fixing only the first error and declaring victory.** `validate` goes red again in the sorters module; the
  on-call who stops after belts hands over a broken pipeline.
- **Applying as soon as validate passes.** The belts module still has `byte_length = 4`: four serials replaced,
  four controllers need reflashing.
- **Hard-coding `130` and `"transfer"` in the dispatch outputs.** The board looks right today and is wrong the
  next time a belt is added.
- **Reverting the release wholesale.** It restores the old plan but throws away the capacity feature the airport
  asked for, and the same breakage returns on the next merge.
- **Using `-target=module.belts`.** It makes the first layer apply and leaves the others unplanned, which is the
  opposite of what a cascade needs.
