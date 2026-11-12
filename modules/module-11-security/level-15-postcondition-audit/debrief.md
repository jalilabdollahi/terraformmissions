# Debrief — verify the result, not only the request

A `precondition` asks "is it safe to try?" A `postcondition` asks "did what we got meet the standard?". Because it runs after the provider has returned, it can inspect real attributes
of `self`: the file mode that exists on disk, the tags a cloud service really applied, the TLS version the endpoint actually negotiates. That makes it the natural home for audit rules
where the configured value and the real value might differ.

In this mission the audit looks at the world through a data source (an `external` script reading the file's true mode), and the postcondition lives on that data source.
This pattern — "create, then read back and assert" — catches providers that silently clamp or ignore a setting, umask surprises, and drift introduced later: the postcondition on a data source
is also re-evaluated on every plan, so a key that someone `chmod`ed to 0644 fails the next run.

Keep two things in mind. A weak condition gives false assurance, which is worse than none: the stock phrase "must exist" proves nothing about security. And a failed postcondition does
not roll back — the object has been created, and Terraform stops. Treat the failure as an alarm: fix the cause, then re-apply. Combined with a precondition on inputs and validation on variables, it forms a
defence in depth for a policy.
