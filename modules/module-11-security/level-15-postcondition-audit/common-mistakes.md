# Common Mistakes

- **Postcondition expected value doesn't match resource value** — always verify both are aligned.
- **Using precondition instead of postcondition for state checks** — use `postcondition` when
  you need to verify the *resulting* state after apply.
- **Forgetting `self.` prefix** — inside postcondition, resource attributes are accessed via `self`.