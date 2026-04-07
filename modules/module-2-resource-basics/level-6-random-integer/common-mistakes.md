# Common Mistakes

- **Reversing `min` and `max`** — always ensure min is the smaller value.
- **Using `random_integer` for port numbers without checking valid ranges** — valid TCP/UDP ports are 1–65535.
- **Forgetting `keepers`** — without keepers, the integer only regenerates when the resource is replaced.