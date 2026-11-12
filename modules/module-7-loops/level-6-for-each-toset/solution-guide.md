# Walkthrough - Saffron Twice

1. `terraform plan` fails with *Invalid for_each argument ... must be a map, or set of strings, and you
   have provided a value of type list of string*.
2. A list is ordered and may repeat values; instances of `for_each` are identified by unique keys, so
   Terraform refuses to guess which element becomes the key.
3. Convert the list to a set:
   ```hcl
   for_each = toset(var.spices)
   ```
4. Apply. `terraform state list` shows `local_file.stall_tag["cardamom"]`, `["saffron"]`, `["sumac"]`
   and `["za-atar"]` - four tags, because the duplicated saffron collapses. Keep `var.spices` as a list;
   only the `for_each` expression changes.
