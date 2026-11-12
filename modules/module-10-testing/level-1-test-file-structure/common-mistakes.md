# Common mistakes

- **Deleting the test file.** `terraform test` then reports `0 passed, 0 failed` and exits 0, but the price formula is untested again - the mission checks that the three scenarios still exist.
- **Renaming only the first block.** Every `test "..."` block fails the same way; fix all three.
- **Moving the assertions to the top level.** `assert` is only valid inside a `run` block (`Unsupported block type`).
- **Changing the price formula so the old expectations match.** The formula is correct; the file structure is what is broken.
