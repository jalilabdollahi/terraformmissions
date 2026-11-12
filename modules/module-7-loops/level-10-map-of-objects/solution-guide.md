# Walkthrough - Slot Slips

1. `terraform plan` stops at the `content` line: *Invalid template interpolation value ... Cannot include
   the given value in a string template: string required* - the value is an object.
2. `var.slots` is `map(object({ volunteer, boxes, time }))`. In `for_each = var.slots`, `each.key` is the
   slot name (a string) and `each.value` is the whole object.
3. Access the attributes with dots:
   ```hcl
   content = "Slot ${each.key}: ${each.value.volunteer} collects ${each.value.boxes} boxes at ${each.value.time}\n"
   ```
4. Apply: `slips/early.txt`, `slips/noon.txt` and `slips/sunset.txt` each read correctly, and
   `total_boxes` is 40.
