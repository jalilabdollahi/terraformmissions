# Walkthrough - Briggs Twice

1. `terraform plan` fails with *Invalid for_each argument ... must be a map, or set of strings, and you
   have provided a value of type list of string*.
2. A list is ordered and may repeat values; instances of `for_each` are identified by unique keys, so
   Terraform refuses to guess which element becomes the key.
3. Convert the list to a set:
   ```hcl
   for_each = toset(var.dealers)
   ```
4. Apply. `terraform state list` shows `local_file.stall_tag["ashby"]`, `["briggs"]`, `["calloway"]`
   and `["dunmore"]` - four tags, because the duplicated briggs collapses. Keep `var.dealers` as a list;
   only the `for_each` expression changes.
