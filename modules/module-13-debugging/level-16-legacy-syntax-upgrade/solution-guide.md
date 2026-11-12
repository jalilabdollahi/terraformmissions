# Walkthrough - Comic Con Legacy Syntax

1. `terraform validate` fails on `variables.tf`: `Invalid quoted type constraints`. Replace `"string"`, `"list"`, `"map"` with
   `string`, `list(string)` and `map(number)`.
2. Next errors: `Call to unknown function "list"` / `"map"`. Their messages even say what replaced them. Write the collections directly:
   `["cosplay", "meet and greet"]` and `{ cosplay = 2, "meet and greet" = 5 }`.
3. `depends_on = ["local_file.programme"]` only raises `Quoted references are deprecated`, but it belongs to the same cleanup: it takes references, `depends_on = [local_file.programme]`.
4. Now the warnings: `Interpolation-only expressions are deprecated`. Wherever a string is just `"${expr}"`, drop the quotes and the `${}`:
   `"${var.stalls}"` -> `var.stalls`, `"${local.extras}"` -> `local.extras`, `"${length(var.stalls)}"` -> `length(var.stalls)`.
   Keep `${...}` inside strings that contain other text.
5. `terraform validate` -> `Success! The configuration is valid.` with no warnings. `terraform apply`, then `check`.

Tip: `terraform fmt` and `terraform 0.12upgrade`-style tools are gone; for very old code, step through the upgrade guides, but for small repositories manual edits are quicker.
