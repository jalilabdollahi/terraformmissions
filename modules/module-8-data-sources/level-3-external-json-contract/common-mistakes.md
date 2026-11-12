# Common mistakes

- **Wrapping the data source result in `jsondecode()` on the Terraform side.** The JSON is rejected
  before Terraform ever sees `result`; the fix has to happen in the program's output.
- **Stringifying only the numbers.** The list and the nested `limits` object still break the
  contract. Every value must be a plain string.
- **Hard-coding `"303"` in the script.** The validator edits `jumpers.csv`; the totals must be
  computed from it.
- **Printing a second line or a debug message to stdout.** Stdout must be one JSON object; send
  diagnostics to stderr.
- **Renaming the key to `max` or `limit`.** `main.tf` reads `max_kg`; keep the names in sync with
  what Terraform expects.
