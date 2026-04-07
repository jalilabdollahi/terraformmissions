# Common Mistakes

- **Passing lists to set functions** — always use `toset()` to convert first.
- **Assuming set order** — sets are unordered; don't rely on element position.
- **Duplicate removal** — `toset(["a","a","b"])` silently removes the duplicate; be aware.