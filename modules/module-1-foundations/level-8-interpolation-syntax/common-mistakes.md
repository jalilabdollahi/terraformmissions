# Common mistakes

- **Hard-coding the values (`Station: Kestrel Ridge`).** The first apply looks right, but the validator
  re-applies with different variable values and the bulletin does not follow them.
- **Fixing one line and missing the other.** The bug appears twice; check all three lines of the file.
- **Putting the whole string in the braces.** An expression like `Station: var.station` inside `${ }` is parsed as
  code and fails; only the expression goes inside.
- **Escaping with a doubled dollar sign.** That produces a literal `${...}` in the file, the opposite of what you want.
