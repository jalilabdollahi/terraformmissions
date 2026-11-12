# Common mistakes

- **Deleting the `fileexists` assertion.** The run passes, but nothing proves the card is written any more; the mission re-checks that the check still exists.
- **Switching every run to `command = apply`.** It works, but it needlessly creates and destroys resources for checks that only read outputs.
- **Creating `kiln/recipe.txt` by hand.** Terraform test runs in the module directory but the file would not belong to the config, and teardown would not clean it.
- **Wrapping the check in `try()` to hide the error.** It turns a missing file into a quiet false.
