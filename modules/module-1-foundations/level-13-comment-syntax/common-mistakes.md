# Common mistakes

- **Fixing only the first line.** Each foreign comment style fails separately: `--`, `;` and `<!--` all need converting.
- **Wrapping the HTML comment in `#` on its first line only.** The following lines are then bare text and
  produce new errors; use `/* ... */` or put `#` on every line.
- **Deleting the notes and the variable together.** The comments can go, but the `markup_pct` variable and the
  records are real configuration and must stay.
- **Using `/* ... */` inside a string.** Inside quotes it is ordinary text, not a comment.
