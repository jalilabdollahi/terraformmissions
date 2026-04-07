# Common Mistakes

- **Using the resource name instead of the for_each key** — the key is from the map, not the
  resource type name.
- **Forgetting quotes around string keys** — `output.files[alpha]` is a reference, not a key
  lookup; use `output.files["alpha"]`.
- **Assuming numeric indices** — `for_each` maps use string keys, not sequential numbers.