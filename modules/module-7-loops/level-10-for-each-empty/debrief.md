# Empty for_each Map

## What Was Broken
`var.items = {}` creates zero `local_file` instances.
`local_file.items["main"]` fails because the `"main"` key doesn't exist.

## Adding a Default Entry
```hcl
variable "items" {
  type = map(string)
  default = {
    main = "default"
  }
}
```

## Defensive Output Access
If the map might be empty, use `try()`:
```hcl
output "main_file" {
  value = try(local_file.items["main"].filename, "")
}
```

## Concepts
- An empty `for_each` map creates zero resources
- Always consider the empty case when accessing `for_each` resources by key