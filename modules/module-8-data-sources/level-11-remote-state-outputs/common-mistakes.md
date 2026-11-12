# Common mistakes

- **Editing `stage-crew/main.tf` to add `stage_plan`.** That is another team's configuration, and the
  state the box office reads would not change until the crew re-applied. The consumer adapts.
- **Fixing the name but not the index.** The second error appears right after the first.
- **Converting with `tomap(...)` to keep `["rigging"]`.** A list has no such key; conversion
  produces keys "0", "1", not role names.
- **Hard-coding 160 and the rigger's name.** The validator changes the crew's seats and leads and
  expects the box office to follow.
- **Dropping the `terraform_remote_state` data source for a local value.** The mission is about
  reading the crew's outputs.
