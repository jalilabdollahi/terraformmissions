# Common Mistakes

- **Base CIDR too narrow** — adding bits to a `/24` quickly runs out of address space.
- **Off-by-one in netnum** — subnets are 0-indexed; the maximum index is `2^newbits - 1`.
- **Overlapping CIDRs** — when generating multiple subnets, use consecutive netnum values.