# Type Mismatch: String Masquerading as Number

## What Was Broken
The variable declared `type = number` but provided `default = "hello"`. The string `"hello"`
cannot be converted to a number, so Terraform reports a type mismatch during validate.

## The Fix
```hcl
variable "app_name" {
  type    = string
  default = "hello"
}
```

## Terraform Variable Types

| Type keyword      | Example default value |
|------------------|-----------------------|
| `string`          | `"hello"`             |
| `number`          | `42`, `3.14`          |
| `bool`            | `true`, `false`       |
| `list(string)`    | `["a", "b"]`          |
| `map(string)`     | `{ key = "val" }`     |
| `object({...})`   | `{ name = "app" }`    |
| `set(string)`     | `["a", "b"]`          |
| `tuple([...])`    | `["hello", 42]`       |

## Why It Matters
Declaring an explicit `type` constraint makes variables self-documenting and prevents callers from
passing the wrong kind of value. The type check happens at validate time — before any resources
are created.