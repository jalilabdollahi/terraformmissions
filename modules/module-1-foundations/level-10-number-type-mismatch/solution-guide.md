# Walkthrough — Gilded Heron Quiz

1. **Run `terraform validate`.** It reports the variable first; once that is fixed, the resource argument is reported:
   ```
   Error: Invalid default value for variable
     on main.tf line 5, in variable "teams":
   This default value is not compatible with the variable's type constraint: a number is required.

   (second run)
   Error: Incorrect attribute value type
     on main.tf line 19, in resource "random_shuffle" "round_one":
   Inappropriate value for attribute "result_count": a number is required.
   ```
2. **Spot the words.** `"eight"` and `"three"` are strings that do not look like numbers.
3. **Write real numbers.** `default = 8` and `result_count = 3` (digits, no quotes).
4. **Apply.** `terraform output` should show `team_count = 8` and three questions.
