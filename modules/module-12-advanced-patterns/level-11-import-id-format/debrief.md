# Debrief: the import ID is whatever the provider says it is

`id` in an import block is a string handed straight to the provider's import function. There is no universal
format. Many AWS resources use the name or a numeric ID, Azure uses the full resource path, and a
subnet in some providers needs `vpc_id/subnet_id`. Here the three provider resources show how far it can vary:
`random_integer` packs three values separated by commas, `time_static` takes the timestamp, and `random_id`
takes the base64-url text.

Two different failure modes appear. A malformed ID fails loudly, immediately, with an error naming the expected
format. A well-formed but wrong ID is worse: the hex string decoded to a different length and Terraform planned to replace
the imported object. Imports that need replacing are a red flag: the configuration does not describe the thing you imported, so you must change the
configuration (or the ID) before applying. In this level the `rfc3339` and `triggers = {}` arguments on
`time_static` exist for exactly that reason: they make the configuration match the imported attributes.

Always check the "Import" section of the resource page, try the import in a plan before applying, and read
whether the plan says `will be imported` with no `must be replaced` next to it.

Real-world takeaway: after any import, the first plan should show zero changes for the imported object. If it
shows a diff, adjust the configuration, not the infrastructure.
