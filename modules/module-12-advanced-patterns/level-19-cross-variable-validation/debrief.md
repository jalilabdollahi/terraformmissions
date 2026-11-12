# Debrief: validate inputs where they are declared

Variable validation used to be limited to the variable's own value: you could say "this string is lowercase" but
not "this number fits the other variable". Terraform 1.9 lifted that restriction: a `validation` condition can reference other input
variables, locals, data sources and resources of the module. Relationships between inputs, such as "end after start",
"min is below max", "if `enable_tls` is true a certificate must be given", can now be expressed once, next to
the variable the caller touches.

Why is that better than a `precondition` on whichever resource uses them? Timing and message. Variable validation
runs at the very start, before any provider is asked anything, and the error names the variable and the rule. A resource
precondition runs while the plan is being assembled, and reports a resource address instead. When several
resources use the same input you would also have to repeat the check.

Which variable gets the validation? The one the caller should be told to fix. Rules about a pair go on the variable
that is more likely to be wrong (here `students` and `end_hour`).

For facts about real objects, such as an attribute that only exists after apply, a `precondition` or a
`check` is still the right tool.

Real-world takeaway: put every rule about inputs on the variables, test them with `-var` probes (including the exact
boundary), and keep preconditions for facts about real objects.
