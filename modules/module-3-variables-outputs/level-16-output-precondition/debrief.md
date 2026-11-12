# Debrief — guard the thing you publish

Terraform has several places to assert things, and each has its own job:

- `variable { validation { ... } }` — is this *input* acceptable? It sees only that variable (and, since
  Terraform 1.9, other variables and data sources, but not resources).
- `resource { lifecycle { precondition / postcondition } }` — is this resource allowed to be created, and
  did it come out as expected?
- `output { precondition { ... } }` — may this *published value* leave the module? It can reference
  anything the output can see: variables, locals, resource attributes.

The cheese cave's rule is about what is offered for sale, so the output is the natural place. The
precondition runs at plan time when the inputs are known, so a bad wheel is rejected during review, long
before the shop's feed changes. It reads the minimum from a variable, which keeps the policy adjustable
without editing the check.

An output precondition does not stop *other* resources from being planned in isolation, so keep
the guard close to the published value and consider a `terraform_data` or a resource precondition if the
side effects (here, `label.txt`) must also be blocked. In this level the failure aborts the whole run
because the output is evaluated during planning.

## Real-world takeaway

Write down the invariant ("nothing below the minimum is published"), then put the check where the
invariant is violated: at the published value. A comment is a wish; a precondition is an enforcement.
