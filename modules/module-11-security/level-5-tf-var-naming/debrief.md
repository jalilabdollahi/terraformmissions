# Debrief — environment variables match by name, exactly

Terraform's `TF_VAR_` mechanism has no fuzzy matching. The name after the prefix must equal the variable name, and it is
case-sensitive on Linux and macOS. Variable names that Terraform accepts (`club-region`, `ArmouryCode`) can therefore be
perfectly valid HCL and still impossible to feed from a typical CI system: POSIX environment variable names cannot contain hyphens,
and many CI UIs force upper-case names, so a mixed-case variable can never be matched.

The pragmatic convention is snake_case lower-case variable names everywhere. It reads well in HCL, maps directly to `TF_VAR_snake_case`,
and keeps modules interoperable with each other.

Also note what the environment *can* carry. Lists, maps and objects are parsed as HCL, which is why `TF_VAR_squad_roster='["foil","epee","sabre"]'`
works for a `list(string)`. Strings are taken literally, with no quoting. When a required variable has no value, the
non-interactive error ("No value for required variable") is your signal that a name does not match: check spelling and case before you check the CI secret store.
