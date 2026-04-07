# CIDR Subnet

## What Was Broken
`cidrsubnet("10.0.0.0/24", 8, 1)`:
- Base: `/24` (256 addresses)
- Add 8 bits: `/24 + 8 = /32` (a single address)
- A `/32` has only 1 address (index 0), so index 1 overflows

## The Fix
```hcl
locals {
  subnet = cidrsubnet("10.0.0.0/16", 8, 1)
  # Base /16 + 8 bits = /24 subnet
  # Index 1 → "10.0.1.0/24"
}
```

## cidrsubnet() Math
```
cidrsubnet(prefix, newbits, netnum)
```
- `prefix` — the base CIDR block (e.g., `"10.0.0.0/16"`)
- `newbits` — number of additional bits for the subnet mask
- `netnum` — zero-based subnet index

```hcl
cidrsubnet("10.0.0.0/16", 8, 0)  # → "10.0.0.0/24"
cidrsubnet("10.0.0.0/16", 8, 1)  # → "10.0.1.0/24"
cidrsubnet("10.0.0.0/16", 8, 255) # → "10.0.255.0/24"
```

## Why It Matters
CIDR math errors are easy to make and can lead to overlapping subnets, routing problems,
or silent failures at apply time when the cloud provider rejects the address range.