# Common mistakes

- **Changing the variable types in `coop.tf` to `any`.** It lets the bad overrides through but the mission checks the declared types and a mutant of the code; the assertions would then fail on garbage values.
- **Fixing `crowded_coop` only.** `bantam_flock` is skipped until then; after the first fix it fails with the map error.
- **Writing `stock = { bantam = "30" }`.** A string "30" converts to a number, so it works, but the validator wants a real numeric 30 in the test file as the scenario describes.
- **Removing the override so the default stock is used.** The run no longer describes a crowded coop and its assertion fails.
