# Common mistakes

- **Adding `depends_on` between the two resources.** The order is now deterministic, but the second writer still erases the
  first one's text, and the plan is still not clean.
- **Deleting one of the resources.** The board then holds only half of the information.
- **Adding `ignore_changes = [content]` to one of them.** It silences the plan and leaves the board incomplete.
- **Giving the second resource a different filename.** The mission needs a single notices.md.
- **Typing the combined text into the file by hand.** Terraform must own it, and the content must follow `local.intro` and `local.events`.
