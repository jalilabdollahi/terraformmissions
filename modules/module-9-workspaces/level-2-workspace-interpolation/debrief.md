# Debrief: terraform.workspace is a value, not a word

`terraform.workspace` is a built-in reference, in the same family as `path.module` and `each.key`. It
evaluates to the name of the selected workspace, as a string. Because it is an ordinary expression, all
the usual HCL rules apply and all the usual typing mistakes happen:

- inside quotes it is text, so `"terraform.workspace"` is exactly that sixteen-character string;
- inside a template it needs `${...}`, and a bare `{...}` is printed as it is;
- as a function argument or assignment it should be written bare, with no quotes and no template.

The quiet trap is that none of these mistakes is an error. Terraform happily creates a file called
`terraform.workspace-crates.txt`, in every workspace, so all harvests share it. Plans look healthy right
up to the moment two environments overwrite each other.

Good habits: derive the name once (`locals { harvest = terraform.workspace }`) and reference the local,
run `terraform console` and type `terraform.workspace` to see what you get, and look at the *names of the
files and resources actually created*, not just the exit code of `apply`.

**When workspaces are the wrong tool:** workspace names often end up inside resource names, bucket names and
tags. If names need to be globally unique, differ by account, or follow strict length rules, an explicit
`environment` variable with a validated value is clearer than whatever string somebody typed into
`workspace new`.
