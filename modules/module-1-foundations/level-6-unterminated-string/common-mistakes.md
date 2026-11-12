# Common mistakes

- **Fixing the last error in the list.** Later errors are fallout from the unterminated string; the
  first error is the one that points at the real problem.
- **Turning the string into several lines with real line breaks.** Quoted strings cannot span lines;
  use `\n` or a heredoc.
- **Adding the quote on the *next* line.** The closing quote must be on the same line as the opening one.
- **Escaping the wrong quote (`\"` at the end).** That leaves the string open and adds a new error.
