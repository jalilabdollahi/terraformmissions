# Common mistakes

- **Wrapping the output in `sensitive()` while keeping `data "local_file"`.** The output is masked but
  the plan and apply logs for the door card still show the combination.
- **Using `nonsensitive()` to get rid of the "refers to sensitive values" error.** That strips the
  flag you just gained and leaks the secret again.
- **Marking the output sensitive and forgetting the file mode.** The card stays world readable.
- **Deleting the output.** It must stay and return the real value through `terraform output`.
- **Believing `sensitive = true` encrypts state.** It only masks display; state still holds the
  value in clear text.
