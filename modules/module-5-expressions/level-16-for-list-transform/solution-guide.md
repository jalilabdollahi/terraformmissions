# Walkthrough — Wickham Jar Labels

1. `terraform plan` ends in `Invalid operand ... Unsuitable value for left operand: a number is
   required` on `position + 1`. The variable called `position` holds "Lavender".
2. Test iterator order in `terraform console`:
   ```
   > [for a, b in ["x","y"] : "${a}/${b}"]     # ["0/x","1/y"]  index first, value second
   > [for a in ["x","y"] : a]                  # ["x","y"]      one name = the value
   ```
3. Swap the names: `[for position, scent in var.scents : ...]`.
4. The next error is `Unknown variable; There is no variable named "wax"`. A `for` expression only
   knows the names it declared (`batch`), so use `batch.scent` and `batch.wax_g`.
5. Apply and run `check`.
