# Common mistakes

- **Deleting `lanes/lane-7.txt` by hand.** The file disappears, but lane 7 is still in state and the
  receipt provisioner never ran; the validator checks both.
- **Putting the resource block back and running destroy with -target.** The mission asks for a removed
  block in the code, not a one-off command.
- **Deleting the removed block altogether.** Terraform would destroy the sheet, but without the
  provisioner, so no receipt is written.
- **Moving the provisioner into a resource block.** A destroy provisioner only runs for an object
  that is still declared or covered by a removed block.
