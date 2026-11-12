# Debrief: decide what an unknown workspace means

Anyone can run `terraform workspace new`, so the set of workspaces is open-ended, while a ternary chain or a
settings map covers a closed list. Eventually somebody creates a workspace the code has never heard of, a
pull request preview, a hotfix, a typo. Your configuration then needs a deliberate answer to "what
happens here?" It has three reasonable ones:

1. **Fail loudly.** A map index with no default: great for environments like prod where a typo must never
   produce a weak copy.
2. **Fall back to a safe minimum.** What this level asks for, one lane. It suits ephemeral workspaces.
3. **Fail with a clear message.** A `precondition` that lists the allowed names.

The unnoticed part of this bug is where it surfaced. The module's input validation caught the bad value
and named the variable, but the real fault was one module up, in the expression that computed it. When a
module rejects an input, read it as a pointer to the *caller*. Weakening the module (allowing 0) would have
turned an error into a silent empty alley.

`lookup(map, key, default)` replaces a nested ternary with data, which is easier to read and review, and a
new environment becomes a one-line addition to the map.

**When workspaces are the wrong tool:** preview environments per pull request are a fine use of
workspaces, but long-lived environments that differ in size, features and ownership deserve their own
variable files or root modules. A default value cannot save you from environments that are really
different systems.
