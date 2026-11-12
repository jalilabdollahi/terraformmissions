# Common mistakes

- **Wrapping the value in `nonsensitive()`.** The plan goes through and the secret is printed to every CI log.
- **Marking only the root output.** Terraform stops complaining, but the module's interface still hides that its output is a
  secret. The next caller who prints it into a log gets no warning, so mark both.
- **Replacing `random_password` with `random_string`.** The value stops being sensitive, but the mission is about
  keeping secrets secret, and the validator expects `random_password`.
- **Deleting the root output.** The code must stay retrievable with `terraform output -raw door_code`.
