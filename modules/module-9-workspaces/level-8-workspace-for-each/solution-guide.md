# Solution guide

**Diagnose.** The plan fails with *Invalid for_each argument*: "The given "for_each" argument value is
unsuitable ... must be a map, or set of strings, and you have provided a value of type tuple."

**Fix.**

```hcl
for_each = toset(local.active)
```

In `network` the list contains `dovecote` twice. A set holds each value once, so you get four instances,
not five, and the output reports 4.
