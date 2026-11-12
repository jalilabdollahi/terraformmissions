# Common mistakes

- **Adding the brace right after the line number in the error.** That line is where the block opens;
  the closing brace belongs after the block's last argument.
- **Adding a `}` in the middle of the file.** The earlier blocks were fine. Now they parse, but the
  stray brace produces a new "Unbalanced closing brace" error.
- **Deleting the `oven_schedule` resource to silence the error.** The parser is happy but the schedule
  file never gets written, and the mission needs it.
- **Commenting out the whole file.** `terraform validate` goes green because nothing is left to check.
