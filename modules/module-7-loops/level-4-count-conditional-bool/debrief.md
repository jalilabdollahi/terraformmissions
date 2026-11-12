# Debrief - give switches a boolean type

The idiom `count = var.enabled ? 1 : 0` is how Terraform expresses "create this resource optionally".
The ternary operator requires a true or false condition. Terraform is lenient in one narrow way: it will
convert the *strings* "true" and "false" to a bool. Any other word - "on", "yes", "enabled", "1" - is a
hard error, and rightly so, because guessing what "off" means is how production toggles break.

There are two ways out. You could keep the string and write `var.floodlights == "on" ? 1 : 0`, but then
every caller has to remember the magic word, and a typo such as "On" silently means *off*. The better
fix is to give the variable the type it is semantically: `bool`. Terraform then validates the value at
the boundary and the rest of your code simply uses it as a condition.

## Real-world takeaway

Feature flags should be `bool`. If you must accept human-friendly strings (for example from a CI
variable), convert once at the edge with a `local` and validate with a `validation` block, rather than
sprinkling string comparisons through resources. Also remember what a conditional count does to
addresses: when the flag is on, the resource is `local_file.floodlight_schedule[0]`; when it is off, there
are no instances at all. Anything that references it later must cope with an empty list, a theme you will
meet again with conditional modules at the end of this module.
