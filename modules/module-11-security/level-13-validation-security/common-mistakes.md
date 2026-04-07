# Common Mistakes

- **`<=` vs `>=` confusion** — always read the error message and verify the condition matches it.
- **Not testing the validation** — run `terraform plan` with both valid and invalid inputs to
  confirm the validation fires in the right cases.
- **Validating only length** — real password policies also check character sets, dictionary
  words, and previous password history.