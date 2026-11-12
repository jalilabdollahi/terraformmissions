# Debrief — check the invariant where the object lives

A `precondition` is a guard attached to a resource: Terraform evaluates it before creating or changing the object and refuses to proceed with a message you wrote.
Compared with variable validation, it can look at values from the whole configuration (other variables, data sources, each.value of a `for_each`) and it names the
exact instance that failed. This makes it the right place for invariants that involve more than one input, or that must hold for each element of a collection.

The failure mode in this mission is common: the *message* describes the policy, but the *condition* checks something weaker. Reviewers read the message, trust it, and a
rule that was never tested against a violating input goes unnoticed for months. Always write at least one deliberately failing input when you add a guard, and read the condition, not the error text.

Also notice that tightening the rule exposed existing violations. That is a feature: the next plan tells you exactly which of today's objects are out of policy.
Roll such rules out the same way — add the guard, see what fails, then fix the data — and consider pairing it with a postcondition (next level) that checks the object that actually came out of the provider.
