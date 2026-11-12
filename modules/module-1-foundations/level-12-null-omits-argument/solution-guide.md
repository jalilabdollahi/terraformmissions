# Walkthrough — Static And Signal Slugs

1. **Apply and read.** `terraform apply` then `terraform output slug` shows something like `epwisefox`. There is
   no error: the separator is simply empty.
2. **Why.** `var.slug_separator` defaults to `""`, and that value is passed to `random_pet.separator`. An empty string
   is a legitimate separator ("join with nothing"), so the provider's default `-` is not used.
3. **Fix.** Make the variable default `null`: `default = null`. A null argument is treated as if it had not been
   written, so the provider default applies. (Alternative: keep the `""` default and write
   `separator = var.slug_separator == "" ? null : var.slug_separator`.)
4. **Verify both paths.** `terraform apply` gives `ep-wise-fox`; `terraform apply -var slug_separator=_` gives
   `ep_wise_fox`.
