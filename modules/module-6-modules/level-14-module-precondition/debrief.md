# Debrief — a guard that is wrong fails loudly in both directions

A `precondition` inside a resource's `lifecycle` block is a check Terraform runs during plan, after input values are
known but before it touches that resource. Put it inside a module and it becomes a guard that travels with the
code: any caller who feeds the module an impossible combination of inputs gets the author's message at plan time
instead of a half-built environment.

Guards have a cost, which this level shows: they are code, and code has bugs. A rule written as a ternary with its
branches in the wrong order rejects what should pass *and* accepts what should fail. The first symptom (a legal
booking refused) is the lucky one. The invisible symptom (an illegal booking accepted) only shows up when somebody tests
the other side. When you fix or write a precondition, test at the boundaries: the largest legal value, the smallest
illegal one, and the degenerate zero.

Choose the right tool for the job. `validation` blocks on variables can only look at that single variable (and, since
1.9, other variables); `precondition` can combine several inputs and values from other resources, which is what
this guard needs. Preconditions also work in data sources and outputs, and `postcondition` checks results afterwards.

**Takeaway:** put cross-input rules in `precondition` blocks inside the module, give them clear messages, and test both
sides of every limit.
