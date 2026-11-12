# Common mistakes

- **Fixing only one of the two files.** The other still collides and the drift remains.
- **Using `${terraform.workspace}` in the content only.** The content differs per wing, but the path is the
  same, so the last apply still wins.
- **Hard-coding `east` and `west` paths.** It works for the two wings you know and not for the third.
  The validator also requires `terraform.workspace` in the config.
- **Applying one wing and calling it done.** The collision shows up only when both wings are applied.
- **Deleting the second wing's resources from its state.** That hides the symptom and leaves the real files
  orphaned.
