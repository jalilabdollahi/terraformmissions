# Missing Map Key

## What Was Broken
When a data source uses `for_each`, it becomes a **map** of instances. You cannot access it
directly as `data.local_file.files` — you must specify which key you want.

## The Fix
```hcl
output "file_a_content" {
  value = data.local_file.files["a.txt"].content
}
```

## for_each vs count
| Feature    | `count`             | `for_each`                   |
|-----------|---------------------|------------------------------|
| Index type | integer (0, 1, 2)  | string key from map/set      |
| Access     | `resource[0]`       | `resource["key"]`            |
| Stability  | moves on removal    | stable — keyed by value      |

## Iterating All Instances
```hcl
output "all_contents" {
  value = { for k, v in data.local_file.files : k => v.content }
}
```