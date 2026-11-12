# Common mistakes

- **Rewriting the type to match the data** (`tuple([number, string, bool])`). The validator keeps the
  contract and the downstream locals expect id first.
- **Turning the variable into `list(any)`.** Terraform then converts the mixed list to strings and
  `temp_c` becomes the text `"142.5"`, which the output check rejects.
- **Swapping the locals instead** (`var.latest_reading[1]` for the id). It "works" until someone supplies
  a reading that follows the documented order.
- **Quoting the number** (`"142.5"`). It converts, but it's pointless noise and the real problem — the
  order — remains.
