# Debrief - one object, one owner

Terraform assumes every real object is managed by exactly one resource block. Nothing in the language enforces that: you can
point two resources at the same file, DNS record, bucket policy or tag set, and both will happily "create" it. The result is the
behaviour in this level, a flip-flop. Each resource's state remembers what *it* wrote; when the other overwrites the object,
the next refresh notices drift and the next plan wants to repair it, which in turn breaks the neighbour.

How to recognise a dueling pair:

- the plan shows a change on a resource you did not touch, and the change alternates between two resources after each apply;
- `terraform state list` shows two addresses, but the provider documentation (or your cloud console) shows one object;
- two people each insist their resource is "correct", and both are, in isolation.

How to fix it: decide on one owner and make the other contributors *inputs* to it. Compose the content from locals, variables
or module outputs (as here), or use a resource designed for collaboration, such as separate rules/attachments instead of one monolithic
policy. If the duplicate lives in a different Terraform project, the problem moves to coordination: document ownership, and
use `lifecycle.ignore_changes` in the secondary project only for the attributes the owner controls.

Never "solve" it with `depends_on` to force an order. That only chooses the loser of the next apply.
