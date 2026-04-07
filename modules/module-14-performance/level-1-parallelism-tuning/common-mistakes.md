# Common Mistakes

- **Setting -parallelism=0** — this is invalid and Terraform will error. Minimum useful value is 1.
- **Not checking count before apply** — `count = 0` is valid HCL and silently creates nothing.
- **Confusing -parallelism with -refresh** — they control different phases of the Terraform workflow.
- **Over-tuning parallelism** — very high values can hit provider API rate limits and cause flaky applies.