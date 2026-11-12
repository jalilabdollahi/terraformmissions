# Common mistakes

- **Putting the tilde on the wrong side.** `%{~ for ... }` strips the newline before the directive,
  which glues "Berths:" to the first passenger.
- **Adding `~` to the inline breakfast directive too.** It eats the space before "(breakfast)", giving
  `Mrs Dunlop(breakfast)`.
- **Stripping blank lines with `replace()` afterwards.** Brittle, and the template stays wrong.
- **Joining lines with `join()` and dropping the directives.** It works for the default, but the
  check requires the for and if directives to stay in the template.
- **Forgetting the empty-train case.** With no passengers the `else` branch must disappear entirely.
