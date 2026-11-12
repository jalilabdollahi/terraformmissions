# Solution guide

1. `terraform plan` fails with `Incorrect attribute value type` on `triggers`: a string is required,
   it got a list of string (or similar wording).
2. The `distance` value is a number; Terraform converts numbers to strings automatically, so that one
   is fine. The `cues` value is a list, and lists do not convert implicitly.
3. Encode the list: `cues = join(",", local.running_order)` or `cues = jsonencode(local.running_order)`.
4. `terraform apply`. If you reorder the list later, the trigger changes and `null_resource.cue_sheet`
   is replaced, which is exactly the behaviour the crew relies on.
