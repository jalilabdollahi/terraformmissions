# Debrief — nested loops make nested lists

A `for` expression produces one result element per input element. When the loop body is itself a
`for` expression, each outer element becomes a whole list, so the result is a list of lists. That is
perfectly valid Terraform, and exactly what `for_each` cannot use: `for_each` wants a map or set where
each element is one thing to create.

`flatten()` removes the nesting. It concatenates the inner lists, recursively, so the result is a
single list of objects, one per showing. From there the standard pattern applies: turn the list into a
map with a unique key, `{ for s in local.showings : "${s.screen}/${s.film}" => s }`, and give that map
to `for_each`.

Two reminders about that last step:

- The key must be unique and known at plan time. `"screen/film"` is stable. An index like 0, 1, 2
  is not: inserting a film early in the programme would shift every later resource address.
- Each key becomes part of the address (`local_file.stub["Screen One/Metropolis"]`), so choose keys a
  human can read in a plan.

An empty inner list (the Bar screen in the validator's second programme) produces no elements, so
flatten handles screens with no films without special-casing.

## Real-world takeaway

Subnets per VPC, rules per security group, users per team: any one-to-many relationship in a variable
becomes a nested loop in the code. Flatten once in a local, give the elements a stable key, and the
resources below become plain `for_each` blocks that are easy to review.
