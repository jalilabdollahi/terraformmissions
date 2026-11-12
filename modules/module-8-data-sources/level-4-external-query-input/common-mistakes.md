# Common mistakes

- **Changing the script to read `$1 $2 $3`.** It would work, but the mission is about the data
  source's stdin protocol; the script is the contract and Terraform must send what it expects.
- **Passing a JSON string inside `program`.** Still a command-line argument, so the script still
  sees an empty stdin.
- **Misspelling a query key** (`weight` or `weightg`). The script reports the missing key and exits
  non-zero.
- **Hard-coding the numbers in the query.** The validator changes `-var` values and expects the
  answer to follow.
- **Putting `query` on a `resource` or in `locals`.** It is an argument of the `data "external"`
  block itself.
