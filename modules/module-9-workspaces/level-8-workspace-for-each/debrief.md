# Debrief: sets give resources stable names

`for_each` creates one instance per element and names each instance by its **key**:
`local_file.perch["mill-pond"]`. That is why it only takes maps and sets of strings. A list would
identify instances by position, so removing the first element would renumber the rest and Terraform would
think everything changed. `toset()` converts a list into a set, which has no order, and the elements
themselves become the keys.

Combining this with workspaces is a good fit. The *list* varies by workspace and the *resource block* stays
the same. Each workspace has its own state, so `pilot` and `network` track their own instances. Notice the
file path also contains `terraform.workspace`, otherwise both workspaces would write the same
`elm-hill.txt` (the collision problem in an earlier mission).

Two caveats. `toset` silently drops duplicates, which is helpful here and surprising if the duplicate
mattered; and the keys must be known at plan time, so you cannot build the list from another resource's
attribute that is only known after apply.

**When workspaces are the wrong tool:** if one environment needs a *different shape* (extra resource types,
different dependencies) rather than just more or fewer instances, adding the conditions to the shared code
quickly makes it unreadable. Use modules with an input per environment, or separate root modules.
