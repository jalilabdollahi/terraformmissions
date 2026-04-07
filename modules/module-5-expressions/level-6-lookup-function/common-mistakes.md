# Common Mistakes

- **Missing default argument** — `lookup` always requires a default.
- **Direct map access on optional keys** — `map["key"]` errors if the key is absent; prefer `lookup`.
- **Wrong default type** — the default must be the same type as the map values.