# Walkthrough — Reel Deal Video

1. **Diagnose.** `terraform plan` fails: `Invalid index ... This value does not have any indices.` The
   expression is `var.donated_genres[0]` and the variable is `set(string)`.
2. **Reason.** A set is unordered and has no keys or positions. Terraform refuses `[0]` instead of picking
   an arbitrary element.
3. **Fix.** Decide the order yourself. The mission says "first in the alphabet", so:
   `local.featured = sort(tolist(var.donated_genres))[0]`.
4. **Verify.** `terraform output featured_genre` is `animation`, no matter the order in the default.
