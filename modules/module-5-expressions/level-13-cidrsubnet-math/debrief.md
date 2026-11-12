# Debrief — newbits is a width, netnum is a counter

`cidrsubnet(prefix, newbits, netnum)` does two things at once. `newbits` says **how many bits to add**
to the prefix length, which sets the size of each block. `netnum` says **which block** of that size
you want, counted from zero. The two are linked by a hard limit: `netnum` must be less than
`2^newbits`.

The failing config used 2 new bits. That offers four blocks, `/24` each, and asks for the fifth.
Even if a fifth block had been available the size would be wrong: the estate wanted /26 blocks
with 62 usable hosts, and a /24 has 254. Two different mistakes, one number.

The robust way to think about it is to decide the **target prefix** first and calculate newbits from
the base: `target - base_length`. With that, changing the base range or the block size changes the
plan consistently, and a zone list that outgrows the range fails with an honest error rather than a
quietly overlapping layout.

Other useful companions: `cidrhost()` for a specific address in a block, `cidrnetmask()` for the mask,
and `pow(2, 32 - prefix) - 2` for usable hosts when you need to document capacity.

Remember too that the index in `for index, zone in var.zones` is positional. Removing a zone from the
middle renumbers everything after it. In real networks, give long-lived zones fixed netnums in a map.

## Real-world takeaway

Use `cidrsubnet()` for IP plans, but derive newbits from the sizes you want instead of memorizing
magic numbers, and keep a stable netnum per subnet once anything is deployed.
