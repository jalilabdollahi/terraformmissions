# Common mistakes

- **Changing the map so roles are the keys.** Roles repeat, and a map cannot have two `attendant` keys.
- **Wrapping the file name in `lower(...)` or `replace(...)`.** Cosmetic - the filename is still built
  from the wrong half of the pair.
- **Switching to `for_each = toset(keys(var.crew))`.** Now `each.value` is the name too, and the roles
  are lost.
- **Fixing only the filename.** The cards then have unique names but the Name/Role lines are still
  swapped.
