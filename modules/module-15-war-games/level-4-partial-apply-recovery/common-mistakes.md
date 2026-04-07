# Common Mistakes

- **Panicking and deleting state** — partial state is recoverable; deleting it forces full recreation.
- **Manually editing state to "fix" the partial apply** — almost never necessary and often makes things worse.
- **Not using state locking** — without locks, concurrent applies cause partial state corruption.
- **Applying with -target to "fix" partial applies** — just run a full apply; -target can mask remaining issues.