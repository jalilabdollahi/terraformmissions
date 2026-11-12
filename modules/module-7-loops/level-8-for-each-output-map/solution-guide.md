# Walkthrough - Tickets Without Keys

1. `terraform plan` fails: *Unsupported attribute ... This object does not have an attribute named
   "filename"*. The object it refers to is `local_file.ticket` - a map keyed `night-ferry`,
   `salt-and-iron`, `paper-lanterns`.
2. A `for_each` resource is addressed as a whole by iterating, not by an attribute. Write a `for`
   expression that walks the map and builds a new map of the one attribute you need:
   ```hcl
   value = { for film, t in local_file.ticket : film => t.filename }
   ```
3. Apply and run `terraform output ticket_files` to see a map with the three film slugs as keys.
4. The plan with another `screenings` value now yields a different map - nothing is hard-coded.
