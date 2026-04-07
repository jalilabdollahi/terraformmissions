# Block Identity Crisis

## What Was Broken
`outputs` is not a valid HCL block type. The correct keyword is `output` (singular).

## Valid Top-Level Block Types
| Keyword    | Purpose |
|-----------|---------|
| `resource` | Declare a managed resource |
| `data`     | Declare a data source |
| `variable` | Declare an input variable |
| `output`   | Declare an output value |
| `locals`   | Declare local named values |
| `module`   | Call a child module |
| `provider` | Configure a provider |
| `terraform` | Terraform settings block |

## Why It Matters
HCL is strict about block type keywords. A typo like `outputs` instead of `output` is treated as
an unknown block type and causes a parse error. Unlike some languages, HCL does not silently ignore
unknown top-level blocks.