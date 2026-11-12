# Walkthrough — Kestrel Ridge Bulletin

1. **Apply, then read the output.** `terraform apply` followed by `cat weather/bulletin.txt` prints the
   Station line with the raw text `$(var.station)` and the Altitude line with `{var.altitude_m}`, while the
   Wind line shows `23`. Terraform did not complain: both broken spellings are ordinary characters in a string.
2. **Spot the difference.** Only the Wind line, written `${var.wind_knots}`, was substituted.
3. **Fix the syntax.** Template interpolation is `${ expression }`: dollar, opening brace, the expression, closing
   brace. Parentheses are shell command substitution, and bare braces are nothing at all to Terraform.
4. **Apply again.** Terraform plans an update to the file; the bulletin now has real values.
