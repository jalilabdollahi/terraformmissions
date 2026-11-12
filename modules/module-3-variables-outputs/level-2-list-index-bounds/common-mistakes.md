# Common mistakes

- **Changing `[4]` to `[3]`.** The default now works, but the board still ignores the real length. A
  three-sailing summer timetable would print `Invalid index` again.
- **Appending a fifth time to the default list.** That "fixes" the error by inventing a sailing that does
  not exist, and the output no longer says 17:30.
- **Wrapping in `try(var.departures[4], "n/a")`.** It silences the error and prints a placeholder as the
  last sailing — a wrong answer is worse than a loud error.
- **Using `element(var.departures, 4)`.** Wrap-around returns `06:15`, the *first* sailing, not the last.
