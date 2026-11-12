# Common mistakes

- **Applying the first plan.** It generates 17 fresh serials; the physical labels on the cabinets are now wrong for the whole network.
- **Importing all 17 sites.** The two retired cabinets (old-cinema, closed-pharmacy) are decommissioned hardware; managing them makes the rota system schedule visits to nothing.
- **Leaving `byte_length = 6` for everyone.** Four sites carry 8-byte serials, so those imports plan as destroy-and-recreate because byte_length cannot change in place.
- **Pasting 15 serials into import blocks by hand.** It works once, then the register and the code drift. One `for_each` import reading the register keeps them tied.
- **Using `terraform import` 15 times from the shell.** Nothing is recorded in the repository and the next environment has to repeat the work from memory.
