# Common Mistakes

- **Referencing count module without index** — `module.mymod.output` is only valid for modules without count/for_each.
- **Not handling count=0 case** — always use `try()` when the module might not exist.