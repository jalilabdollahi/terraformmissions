# Debrief: read the schema, not your memory

Every resource type has its own list of arguments (what you set) and attributes (what it exports).
They are not interchangeable across providers: `random_pet` gives you `id`, `random_uuid` gives you
`result` and `id`, `tls_private_key` gives `private_key_pem`, and so on. `terraform validate`
checks every reference against the provider schema without contacting anything, so a wrong
attribute name is found immediately and for free, with the file, line and the reference at fault.

When you hit `Unsupported attribute`, do not guess. Run
`terraform providers schema -json | jq '.provider_schemas[].resource_schemas["random_uuid"]'`, or open
the registry page and read the attribute list. In practice also use `terraform console` after an
apply and type `random_uuid.drop_id` to see all exported values at once.

A small but useful point: `id` is exported by nearly every resource, and for `random_uuid` it equals
`result`. Using `.id` would also have worked here, but `.result` is the documented, intentional
attribute; prefer the name the docs use for the value so your config survives provider changes.
