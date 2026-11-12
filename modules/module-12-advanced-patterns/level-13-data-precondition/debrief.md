# Debrief: precondition looks forward, postcondition looks back

Custom conditions come in two timings, and data sources support both. A `precondition` is evaluated before
Terraform asks the provider to read or create the object. It can use anything already known: variables, locals,
other resources, functions such as `fileexists`. A `postcondition` is evaluated after, and may use `self` to
inspect what came back.

That timing explains the error. A precondition that mentions the data source's own content is asking
for a value that does not exist yet, and Terraform's graph would have the data source depending on itself.

Why bother with a precondition on a data source at all? Without it, a missing file shows up as a provider
read error, such as `no such file`, with no hint of why the path was wrong. With a precondition you
choose the message ("The ladder file must be an existing .csv export"). For real data sources
like a cloud lookup, a precondition might check that an environment variable was set before the query is made.
The postcondition then guards the opposite end: that the lookup returned something your configuration
can safely use, such as an AMI with the right architecture.

Real-world takeaway: write guards for inputs as preconditions and guards for results as postconditions. Test them
by running the plan with a deliberately wrong `-var` and reading the error message you wrote.
