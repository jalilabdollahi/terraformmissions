# Common mistakes

- **Hard-coding the answers** (`value = 12`, `value = "Mei"`). The check feeds a different roster and
  expects the outputs to follow.
- **Adding the missing attribute to the data** (e.g. a top-level `capacity`). That changes the variable's
  type and breaks the `for_each` resources that already read `enclosure.capacity`.
- **Fixing only the first error.** There are three outputs, each broken differently; validate again after
  every fix.
- **Using `[1]` instead of `[0]`** for the lead keeper. The first keeper in the list is the lead.
