# Common mistakes

- **Swapping the blocks for a `for_each` and applying.** All 300 tags are destroyed and re-created, the
  IDs change and the mission fails; always read the plan first.
- **Using `count` and `range(300)`.** Instances are addressed by index, so inserting a seat later
  renumbers everything; the mission also expects meaningful keys like "a-1-01".
- **Typing the 300 map keys into a literal map.** It looks data-driven but is just the same copy-paste in
  another shape; generate the keys from blocks, rows and seats.
- **Leaving a few of the old blocks in place.** The mission requires exactly one `local_file` resource
  block so the config cannot drift apart again.
