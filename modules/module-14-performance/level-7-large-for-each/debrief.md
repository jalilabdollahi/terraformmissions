# Large for_each Optimization

## What Was Broken
The `token_lengths` variable was typed as `map(string)`, but the `random_string` resource
requires its `length` attribute to be a `number`. Terraform's type system does NOT silently
coerce `"8"` (string) to `8` (number) in all attribute contexts — this causes a type constraint
error that blocks planning for ALL 20 resources.

## The Fix
- Change variable type from `map(string)` to `map(number)`
- Remove quotes from all 20 map values

## for_each at Scale
Using `for_each` over a large map is the idiomatic pattern for managing many similar resources:
- Resources are addressed by map key: `random_string.tokens["token_01"]`
- Adding/removing map entries only creates/destroys that specific resource
- `count` forces index-based addressing, causing cascading recreation when items are inserted mid-list

## Performance Consideration
For configs with hundreds of for_each resources:
- `terraform plan` time is roughly O(n) in number of resources
- Use `-parallelism` to tune apply throughput
- Consider state partitioning if the config grows beyond ~500 resources

## Key Takeaway
Always declare variable types precisely. `map(number)` vs `map(string)` is a meaningful
distinction. Validate types with `terraform validate` early in your development cycle.