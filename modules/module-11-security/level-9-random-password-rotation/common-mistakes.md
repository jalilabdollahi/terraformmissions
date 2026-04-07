# Common Mistakes

- **`timestamp()` in keepers** — almost always wrong; causes rotation on every apply.
- **No keepers at all** — password never rotates, even when it should.
- **Keepers tied to resource IDs that change** — if the resource is recreated, the keeper
  changes and triggers another password rotation.