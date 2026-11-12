# Common mistakes

- **Writing three more import blocks by hand.** It works for now, but the mission asks for one block that
  follows the variable; adding a fifth ticket would need a fifth block.
- **Using `id = each.key`.** The key is `frame`, not an import ID; Terraform reports an invalid ID format.
- **Applying and then importing with the CLI.** The three new random numbers already exist in state;
  you have to remove them first, and the CLI form skips code review.
- **Changing the resource's `for_each` to only the frame ticket.** That drops three jobs from the board
  instead of adopting them.
