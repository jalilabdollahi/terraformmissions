# Debrief: generators have defaults you did not choose

`random_string` assembles an alphabet from four independent switches: `lower`, `upper`, `numeric`
and `special`. All four default to `true`, so a bare `random_string` with only a length gives you
uppercase, lowercase, digits and punctuation. Whenever the consumer of the string has a format
(DNS labels, bucket names, scanner rules, shell-safe tokens) you have to turn the unwanted classes
off explicitly. `override_special` narrows the punctuation set when you need a few symbols, and
`min_lower`, `min_upper` and friends guarantee at least some of each class.

Changing any of these arguments forces a new value: the random string is generated once at create
time and then lives in state. That is why the plan shows `-/+ replace` and the file that embeds the
number is rewritten too. Terraform's random resources are "stable until replaced", not random on
every run; use `keepers` when you want a new value tied to another input.

Real-world takeaway: write the naming rule next to the generator and, better, validate the consumer
side as well (a `precondition` or a `validation` regex). A resource name that violates a cloud
provider's rules usually fails at apply time, after the plan looked fine.
