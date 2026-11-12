# Debrief — split() never returns "nothing"

`split(separator, string)` and `join(separator, list)` look like exact inverses. They are not, and the
gap is made of edge cases.

- **An empty string splits into one empty element.** `split(",", "")` is `[""]`, a list of length 1.
  Anything that counts the result, such as `length()`, sizing a `count`, or looping with `for_each`,
  will see one item that does not exist.
- **Separators are literal.** `", "` and `","` are different. Data typed by humans has all of these:
  trailing commas, double commas, spaces around commas.
- **Pieces keep their whitespace.** `" Mill Ford"` is not `"Mill Ford"`, which matters as soon as the
  value becomes a name, a key, or part of a file path.
- **`join()` happily joins blanks.** It inserts the separator around empty items, producing the
  double arrows on the signpost.

The robust pattern is split, trim, filter: `[for s in split(",", csv) : trimspace(s) if trimspace(s) != ""]`.
`compact()` is a shortcut only when you know the blanks are exact empty strings.

## Real-world takeaway

Comma-separated values arrive from environment variables, tag strings and CI parameters, and people
type them. Normalize them once in a local, then work with the clean list everywhere else. Treat the
empty string as a case to test: it is the usual reason a `for_each` suddenly wants to create one
resource too many.
