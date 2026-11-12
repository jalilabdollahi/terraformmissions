# Walkthrough — Boardwalk Lamp Posts

1. **Plan.** The error is `Unsupported attribute ... This object does not have an attribute named "label"`
   (or "Missing resource instance key"). Because of `count`, `module.post` is a tuple of module objects.
2. **Collect all labels with a splat.** `module.post[*].label` produces a list with one label per instance.
3. **Index the last instance.** Indexes start at 0, so with 3 posts the last is `module.post[2]`:
   `module.post[var.posts_total - 1].label` (using `[var.posts_total]` is out of range).
4. **Number the posts.** `number = count.index + 1` — `count.index` works inside the module call just as it does
   in a resource.
5. Apply, try `-var posts_total=5`, then `check`.
