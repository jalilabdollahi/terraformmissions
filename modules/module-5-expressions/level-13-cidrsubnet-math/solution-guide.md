# Walkthrough — Tessera Address Plan

1. `terraform plan` reports: `prefix extension of 2 does not accommodate a subnet numbered 4`.
   It occurs on the fifth zone (index 4).
2. Do the arithmetic: `cidrsubnet(prefix, newbits, netnum)` makes a block of length
   `prefix + newbits`, and `netnum` must be below `2^newbits`. In `terraform console`:
   ```
   > cidrsubnet("10.77.0.0/22", 2, 3)    # "10.77.3.0/24"
   > cidrsubnet("10.77.0.0/22", 2, 4)    # error
   > cidrsubnet("10.77.0.0/22", 4, 4)    # "10.77.1.0/26"
   ```
3. We want /26 blocks inside a /22: 26 - 22 = 4 new bits, 16 possible blocks. Don't type 4; compute
   it: `var.subnet_prefix - tonumber(split("/", var.base_cidr)[1])`. The check also splits a /21
   into eight /24 blocks.
4. Apply, view `plan/addresses.txt`, run `check`.
