# Common mistakes

- **Reaching into the module for `module.north_lock.data.local_file.notes`.** Module internals are
  not addressable from outside.
- **Adding `level_cm` outputs to the module and leaving `water_level`.** `water_level` is still not
  an output; every reference must match what the module declares. (Declaring more outputs is a valid
  approach, but then every caller must be consistent.)
- **Moving the data source into the root config.** The mission wants the module to keep wrapping it.
- **Hard-coding the levels in `locals`.** The validator edits the notes and re-applies.
- **Changing the module's `reading` output into a string.** `open_gates` and the log need the
  structured object.
