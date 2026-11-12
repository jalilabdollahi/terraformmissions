# Common mistakes

- **Changing the code to `count`.** Then `[0]` would work, but the cards would be tied to positions; the mission checks that `for_each` is still used.
- **Using single quotes, `['tacotl']`.** HCL strings use double quotes only; keys are also case-sensitive.
- **Dropping the instance asserts and keeping only `length`.** The validator requires the tacotl and pierogi pitch text to be checked by key.
- **Wrapping the access in `try()`.** An invalid index would then become a silent null and the assertion would fail confusingly.
