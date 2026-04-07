# Common Mistakes

- **Constraint too strict** — `= 2.5.0` locks to one exact version; you won't get security patches.
- **Constraint too loose** — `>= 2.0` allows major version bumps with breaking changes.
- **Wrong operator** — `~> 2` allows `3.x`, `4.x` etc. Use `~> 2.5` to stay in the 2.x line.