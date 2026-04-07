# DSA is Not Supported

## What Was Broken
`tls_private_key` only supports three key algorithms:
- `RSA` — classic, widely supported, configurable key size
- `ECDSA` — elliptic curve, smaller keys with equivalent security
- `ED25519` — modern, fast, fixed key size

`DSA` is a legacy algorithm and is not implemented in the HashiCorp TLS provider.

## The Fix
```hcl
resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
```

## Algorithm Comparison

| Algorithm | Key Size     | Use Case |
|----------|-------------|---------|
| `RSA`    | 2048+ bits  | Broad compatibility |
| `ECDSA`  | 256/384/521 bits | TLS, code signing |
| `ED25519`| Fixed 256 bits | SSH keys, modern TLS |

## Why It Matters
Enum-like string arguments require exact values from an allowed list. The provider validates the
string during `terraform validate`. Always check documentation for the list of accepted values.