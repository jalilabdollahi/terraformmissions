# Common mistakes

- **Setting `count = var.bays + 1`.** That creates seven signs, including a stray one, and the last
  label would still be off.
- **Starting the default at 7 or editing `var.bays`.** The bay count is correct; changing it makes the
  signs wrong in a new way.
- **Adding 1 in the filename only.** The file is named bay-01 but its content still says BAY 0.
- **Using `count.index + 1` in the output index.** `local_file.bay_sign[var.bays]` is out of range -
  instance addresses are still zero-based.
