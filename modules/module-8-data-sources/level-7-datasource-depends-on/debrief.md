# Ordering Matters

## What Was Broken
The data source had no explicit dependency on `local_file.writer`. Terraform does not automatically
infer that a data source should wait for a resource to finish — it only sees the file path string,
not the relationship.

## The Fix
```hcl
data "local_file" "output" {
  filename   = "${path.module}/output.txt"
  depends_on = [local_file.writer]
}
```

## When to Use `depends_on` on Data Sources
Normally, if a data source references a resource attribute (e.g., `resource.name.id`), Terraform
infers the dependency automatically. But when the relationship is **implicit** (like a shared file
path), you must declare it explicitly with `depends_on`.

## Key Takeaway
Data sources run during the **planning** phase by default. If a data source depends on a resource
that doesn't exist yet, use `depends_on` to push the data source read into the **apply** phase.