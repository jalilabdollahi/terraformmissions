# Common Mistakes

- **Typos in the resource name** — `local_file.config` vs `local_file.configs` are different.
- **Wrong resource type** — `local_sensitive_file.config` is different from `local_file.config`.
- **Using quoted strings** — `target = "local_file.config"` is wrong; use an unquoted reference.
- **Targeting module resources** — for child module resources use `module.name.resource_type.name`.