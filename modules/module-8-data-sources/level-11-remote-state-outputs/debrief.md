# Debrief — the shape of an output is part of the contract

`terraform_remote_state` exposes the producer's root outputs under `.outputs`, as an object whose
attribute names are the output names. Everything the consumer relies on is therefore a promise made
by *another team's* `output` blocks: the **name** of each output and the **type** of its value.

Both promises were broken here, in opposite ways. `floor_plan` is a name the front desk assumed;
the staff had called it `floors`. And `staff_leads` is a list, while the front desk wrote
`staff_leads["calling"]`, which only makes sense for a map. The first mistake fails at plan with an
unsupported attribute, the second with an invalid index, because Terraform type-checks as soon as the
remote values are known.

How to avoid this class of bug:

- Look before you write. `terraform output -json` in the producer (or `terraform console` on the
  data source) shows exact names and structure, including nested objects.
- Ask producers to add `description` to each output. The floor staff did, and it states what the
  list order means.
- Treat renaming or reshaping an output as a breaking change, just like changing an API response.
  A producer that needs to restructure should publish the new output beside the old one and retire
  the old one when consumers have moved.

Remember also that remote state only provides outputs of the producer's root module. A value that
is not output simply cannot be read.
