# Common mistakes

- **Importing the hex string.** `terraform import random_id.freezer_tag <hex>` succeeds but adopts a different value (the hex text decoded as base64), so the plan then rewrites the label.
- **Swapping the arguments.** The address comes first, the ID second. `terraform import <id> <address>` fails with "resource address ... does not exist".
- **Running `terraform apply` instead.** It generates a brand-new tag and relabels the freezer, which is exactly what the clinic wants to avoid.
- **Wrapping the address in an import block.** Valid Terraform, but not what this mission asks for.
- **Importing and ignoring the plan.** Always check for pending changes after an import; a clean plan is the proof the config matches.
