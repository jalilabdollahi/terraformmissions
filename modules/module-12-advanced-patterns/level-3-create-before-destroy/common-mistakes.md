# Common mistakes

- **Deleting `create_before_destroy`.** The file survives, but the sign is blank during the swap and the
  mission asks you to keep the zero-gap behaviour.
- **Re-running apply until the file shows up.** It creates the file once, but the next advert change
  breaks it again; the collision is in the configuration.
- **Using a random suffix with no `keepers`.** It works only if the suffix changes with the advert; a stable
  suffix keeps the same path and the same bug.
- **Hand-creating the file after apply.** Terraform would not own it; the validator also checks the path
  recorded in state.
