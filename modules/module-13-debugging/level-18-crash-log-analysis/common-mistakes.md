# Common mistakes

- **Blaming `local_file.inspection_report`.** The WARN line mentions it, but the stack and the wrapping error name the external data source.
- **Hard-coding 311 or the report text.** The report must be computed from the probe's readings.
- **Flattening by deleting `readings`.** Without it there is nothing to take the maximum of.
- **Swallowing the problem with `try()` around `result.readings`.** The crash is in the provider; Terraform never gets to run your expression.
- **Writing the Go function name as the resource.** `crashed_resource` is the Terraform address from the `with ...` line.
