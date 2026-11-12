# Common mistakes

- **Wrapping the whole output in `nonsensitive()` to see it.** It prints the code in the test log and the validator rejects `nonsensitive(output.lock_code)`.
- **Removing `sensitive = true` from the output.** That is the actual security control; the validator checks it is still set.
- **Hard-coding an expected code.** The code is random per apply, so the assertion could never pass, and it would leak.
- **Deleting the regex assertion.** The mutation check turns the generator into one that emits special characters and expects the suite to fail.
