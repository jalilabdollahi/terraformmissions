# Debrief — JSON variable files: syntax and shape

`terraform.tfvars.json` (and `*.auto.tfvars.json`) carry the same information as `.tfvars` but are meant for
machine-generated input: a booking system, a CI job, a Python script that dumps `json.dumps(vars)`.
The file is a single JSON object whose **keys are variable names** and whose values are JSON values that
Terraform converts to the declared type.

Two layers of errors are common:

1. **Syntax**: JSON is stricter than HCL. No trailing commas, no comments, double quotes only, no
   unquoted keys. A tool that emits JSON will not get this wrong, but a person editing the file by hand
   will. `jq . file.json` or `python3 -m json.tool file.json` shows the exact position.
2. **Shape**: valid JSON can still be the wrong type. Terraform converts values to the variable type
   (the string `"2.4"` can become number 2.4, a JSON object becomes an `object`/`map`), but it cannot turn
   `"36.2,-118.9"` into an object. The error message names the variable, so check the declaration.

Remember that a JSON variable file replaces nothing: it is loaded in the same slot as `terraform.tfvars`
(after it, if both exist), so having both leads to precedence puzzles.

## Real-world takeaway

Generate JSON variable files with a real serializer, never by string-concatenation, and validate the shape
in the producing pipeline (`jq -e '.site.lat'`). When a human edits the file, an editor with JSON linting
catches the comma before Terraform does.
