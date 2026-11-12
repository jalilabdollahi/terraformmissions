# Debrief — the order of variable sources

A Terraform variable can be set from many places, and when several set the same variable, the
**last one wins**. Precedence, from lowest to highest:

1. the variable's `default`
2. environment variables `TF_VAR_name`
3. `terraform.tfvars`
4. `terraform.tfvars.json`
5. `*.auto.tfvars` / `*.auto.tfvars.json`, in lexical filename order
6. `-var` and `-var-file` on the command line, in the order given

This level shows the surprising one: the file with "auto" in its name beats the file that sounds more
official. The dry-run file was meant for a single Thursday, but it stayed in the repository and changed
what range safety had reviewed. Terraform never reports which file a value came from, so the plan looks
perfectly valid.

Debugging tips:
- `terraform console` and evaluate `var.countdown_minutes`.
- `grep -rn countdown_minutes . ` across the directory, including hidden env vars (`env | grep TF_VAR`).
- Prefer one clear mechanism: either a single `terraform.tfvars`, or explicit `-var-file` in the pipeline.

## Real-world takeaway

Temporary overrides should not live next to permanent inputs in an auto-loaded location. Name them
explicitly (`rehearsal.tfvars`) and pass them with `-var-file` when needed, so deleting the flag
restores the reviewed state.
