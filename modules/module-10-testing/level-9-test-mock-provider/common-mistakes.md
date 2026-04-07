# Common Mistakes

- **Empty `mock_provider` block** — you must define `mock_resource` for each resource type used.
- **Forgetting `mock_data` blocks** — data sources also need mocking if used in the config.
- **Setting `defaults` for non-computed attributes** — `defaults` are for computed (unknown at plan)
  attributes; required input attributes must still be set in the resource block.