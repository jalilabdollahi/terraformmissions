# Common mistakes

- **Escaping with a single backslash, `"/\s+/"`.** HCL rejects `\s` as an invalid escape; write `\\s`.
- **Using `regex()` instead of `replace()`.** `regex()` extracts a match, it does not substitute, and
  errors when nothing matches.
- **Fixing only the serial.** All three calls have a separate defect; the date line still shows the
  ISO order if its pattern lacks the slashes.
- **Writing the replacement as `\3/\2/\1`.** Terraform uses `$3/$2/$1` for capture groups.
- **Hard-coding the cleaned strings.** The defaults pass, but another intake form is not cleaned.
