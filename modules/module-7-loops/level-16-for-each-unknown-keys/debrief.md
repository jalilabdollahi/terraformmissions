# Debrief - keys must be known at plan time

Terraform's plan has to answer one question before any change is made: which instances exist? For
`count` that is a number, for `for_each` it is a set of keys. If either depends on a value that does not
exist yet - a random id, a cloud-generated ARN, a created instance's address - Terraform cannot answer it, and
refuses with "keys derived from resource attributes that cannot be determined until apply".

The error is strict on purpose. Unknown keys would make the plan a guess: Terraform could not tell
you what would be created or destroyed, and a later apply could differ from what you approved.

## Identity versus attributes

The way out is to separate the two jobs a string can have. The *key* names an instance and must be known
and stable (here, the sample name). Everything else is an attribute and may be unknown at plan time - the
plan simply shows "(known after apply)". The run id belongs in `filename` and `content`, not in the key.

If you really do need to loop over objects that do not exist yet, the common workarounds are:

- iterate over a static input (a variable or a locals list) and look up the created object by key;
- split the work into two applies (`-target` or two root modules) when the collection is truly dynamic;
- derive keys from a data source that can be read at plan time.

## Real-world takeaway

Keys should come from your *inputs*. When you see this error, trace the key expression back to its source
and find the unknown. The validator checked that adding a sample changed exactly one instance and replaced
nothing, which only holds when the keys are plain, stable names.
