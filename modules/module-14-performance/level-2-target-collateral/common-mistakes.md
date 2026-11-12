# Common mistakes

- **Applying with `-target` again for each missing resource.** You end up with three partial applies
  and Terraform keeps warning; a final untargeted apply is still needed.
- **Using `-replace` on the whole chain "to be safe".** The seal would change and the laundry notice
  fires extra times; the mission needs the original seal and exactly two log lines.
- **Deleting the dependent resources from main.tf.** The plan looks clean, but the roster and the
  notice are gone for good.
- **Running `terraform refresh` and expecting it to restore things.** Refresh only updates state from
  reality; it never creates missing objects.
