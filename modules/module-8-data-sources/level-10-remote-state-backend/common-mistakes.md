# Common mistakes

- **Copying `terraform.tfstate` to where the config looks.** It works once, then goes stale the
  moment the depot team applies again. Point at the live file instead.
- **Changing the depot team's backend path.** That is another team's configuration; the consumer
  adapts to the producer, not the other way round.
- **Using `../depot-team/...`.** Paths are relative to where Terraform runs, not the `.tf` file;
  `${path.module}` is the safe anchor.
- **Hard-coding `NGD-04` and the other values.** The validator changes the bay count in the depot
  team's state and expects the header to follow.
- **Switching `backend = "local"` to `"s3"` or another type.** There is no network or bucket here.
