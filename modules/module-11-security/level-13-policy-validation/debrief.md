# Debrief — validate the policy, not one example of the violation

Variable validation is the cheapest security control Terraform offers: it runs at plan time, before anything is created, and it fails with a message you write.
But a rule that checks for one known-bad string is a blocklist, and blocklists leak. `0.0.0.0/0` has many cousins — `::/0`, `0.0.0.0/1` plus `128.0.0.0/1`, an empty list that your
module may interpret as "allow all". The robust approach is to state what is *acceptable* (an allowlist, or a numeric floor on the prefix length) and to make malformed input fail closed.

Note the shape of the fixed rule. `alltrue` with a `for` expression checks every element rather than just the first, and wrapping the parsing in `can()` converts a would-be crash into a clean validation failure.
Similarly for versions, list the acceptable values rather than excluding a few bad ones, so a future "1.4" or a typo is not silently accepted.

Validation has limits. It sees only the variable's own value (since Terraform 1.9 it may reference other variables, but not resources), and it cannot check what actually got deployed.
Use it as the first layer; the next missions in this module add preconditions and postconditions that check relationships between values and the objects that were created.
Test your rules with deliberately bad inputs, the way this validator does, because a rule that has never been seen to fail has never been proven to work.
