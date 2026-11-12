# Common mistakes

- **Raising newbits to 4 as a literal.** It fixes the default zones and nothing else; the check
  uses a /21 base with /24 blocks and eight zones.
- **Starting the index at 1 to skip the network address.** Subnets are blocks, not addresses; the
  first block (netnum 0) is valid and the expected plan starts there.
- **Changing the base range to a bigger one.** The plan passes with different addresses, but the
  mission fixes 10.77.0.0/22 for this estate.
- **Using `cidrhost()`.** It returns one IP, not a block.
- **Subtracting the wrong way round, `base_length - subnet_prefix`.** That is negative and
  cidrsubnet rejects it.
