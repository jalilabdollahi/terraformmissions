# Debrief — the external data source contract

`data "external"` is the escape hatch for facts Terraform cannot look up natively: you point it at
a program, it runs the program during plan and reads the answer from stdout. The contract is tiny
and strict:

- the program prints **exactly one JSON object**;
- the object is **flat**, and **every value is a string**;
- exit status zero means success; anything on stderr is shown to the user when it fails.

Rich data therefore has to be encoded. Numbers become strings and are turned back with `tonumber()`
on the Terraform side; lists become delimited strings that `split()` reconstructs (pick a separator
that cannot appear in the values) or a JSON string you decode with `jsondecode()`. In this mission the
script was "improved" with a jump master, a nested limit and a list, which is natural for a script author
and exactly what the provider rejects.

Two practical notes. First, the program runs on every plan and refresh, so it must be quick and
free of side effects: it is a query, not a deployment step. Second, because the contract is a
convention rather than a type system, error messages come from JSON decoding and can be cryptic;
running the program by hand and piping it through `jq .` is the fastest way to see what Terraform
sees. Teams that lean on `external` often add a small contract test for the script to their CI so a
well-meaning edit cannot break every plan downstream.
