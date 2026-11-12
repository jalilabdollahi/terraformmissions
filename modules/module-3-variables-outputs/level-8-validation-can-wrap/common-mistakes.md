# Common mistakes

- **Using `try(regex(...), "")` and comparing to `""`.** It can be made to work, but `can()` expresses the
  intent directly and the mission looks for it.
- **Removing the validation.** `terraform plan` then crashes later in the locals when someone passes a bad
  tag, which is worse than before.
- **Changing the message.** The message was fine — the condition never reached the point where it could
  be displayed.
- **Making the regex match everything** (`".*"`). Every bad tag is accepted and the pipeline publishes
  nonsense.
