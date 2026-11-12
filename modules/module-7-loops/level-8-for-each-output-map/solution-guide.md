# Walkthrough - Tickets Without Keys

1. `terraform plan` fails: *Unsupported attribute ... This object does not have an attribute named
   "filename"*. The object it refers to is `local_file.ticket` - a map keyed `poets-night`,
   `crime-panel`, `debut-readings`.
2. A `for_each` resource is addressed as a whole by iterating, not by an attribute. Write a `for`
   expression that walks the map and builds a new map of the one attribute you need:
   ```hcl
   value = { for event, t in local_file.ticket : event => t.filename }
   ```
3. Apply and run `terraform output ticket_files` to see a map with the three event slugs as keys.
4. The plan with another `sessions` value now yields a different map - nothing is hard-coded.
