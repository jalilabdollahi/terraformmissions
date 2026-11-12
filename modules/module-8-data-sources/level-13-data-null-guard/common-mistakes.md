# Common mistakes

- **Wrapping the whole card string in `try()`.** It hides every error, including real bugs, and gives
  the same fallback for all fields.
- **Using only `try(g.diet, "no restrictions")`.** It handles the missing key, but Prudence's explicit
  `null` passes straight through and the interpolation fails.
- **Using only `coalesce(g.diet, ...)`.** `g.diet` is an error for guests without the key.
- **Editing `guests.json` to add the missing keys.** The caterer regenerates that file; the
  validator also supplies its own list.
- **Skipping guests with missing data.** Every guest needs a card; the count is checked.
