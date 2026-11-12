# Debrief - key is identity, value is data

Inside a `for_each` resource, `each.key` and `each.value` describe the entry currently being processed.
With a map they are what you would expect: the key and the value. With a set of strings both are the
same string. Mixing them up is one of the most common beginner bugs because it rarely produces an
error - both are strings here, so Terraform happily builds a file named after a role and a card
saying that the captain's name is "captain".

The consequences go beyond a wrong label. `each.key` is the instance's *identity*: it is what appears
in the address `local_file.duty_card["mara"]` and what Terraform uses to decide whether an instance
already exists. Any argument that must be unique in the real world (a file name, a hostname, a bucket)
should normally derive from the key, because keys are guaranteed unique within a `for_each`.
Values are free to repeat, as with the two deckhands here. Using a value as a name works only until
two entries share it - and with local files, that failure is silent: two instances, one file.

## Real-world takeaway

When you read a `for_each` block, first identify the key and ask what it uniquely names. Put identity
(names, paths, IDs) on `each.key`, attributes (roles, sizes, tags) on `each.value`. If the value is an
object, `each.value.role` is clearer than a bare value, which leads naturally to the map-of-objects
pattern coming up in this module. The validator planned with a crew of two cooks to confirm filenames
follow the key even when values collide.
