# Common mistakes

- **Fixing the assertion to accept whatever random value appears.** The ticket would change on every run; the mission requires station-3 and scoops-8.
- **Quoting the target (`"random_integer.station_slot"`).** The target must be a bare reference; a quoted string is rejected as an invalid expression.
- **Overriding `random_integer.dose` without the module path.** It reports the same warning because that address does not exist at the root.
- **Removing the module from the configuration.** The ticket has to contain the glitter scoops.
