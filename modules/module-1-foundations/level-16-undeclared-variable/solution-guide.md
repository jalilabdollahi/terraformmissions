# Walkthrough — Ribeira River Run

1. **Run `terraform validate`.**
   ```
   Error: Reference to undeclared input variable
     on main.tf line 6, in resource "local_file" "race_sheet":
   An input variable with the name "race_city" has not been declared. This variable can be declared with a variable
   "race_city" {} block.
   ```
   Similar errors follow for `runner_count` and `first_bib`.
2. **Know the rule.** A module is every `.tf` file in the directory, merged together. Variables have to be declared
   with a `variable` block, conventionally in `variables.tf`.
3. **Add `variables.tf`** with the three declarations, types and defaults from the objective.
4. **Apply.** `race/bibs.txt` says `Bibs 1001 to 2200`.
