# Debrief — Inkwell Row Flash Sheets

**What broke.** A resource's address is `<type>.<name>`, here `local_file.flash_sheet`. Terraform builds one graph
from all `.tf` files in the directory, and each address may appear only once. Copy-pasting a block into a new file
is a very common way to break that rule: the file name differs, but the address does not.

**Why the name matters beyond validation.** The address is the key under which Terraform stores the object in
state. If the swallow sheet were renamed instead of the anchor one, Terraform would see "destroy
`local_file.flash_sheet`, create `local_file.swallow_sheet`", and then rewrite the same file. Harmless for a text
file, serious for a database. That is why the validator checks that the *original* address stays in state, and
why you should rename the block you just added, not the one that already exists.

**One file or many.** Splitting resources across files is purely organisational. Terraform merges them. That is why
the duplicate error talks about the other file and line. Meaningful names also help: `flash_sheet` for the first design
and `flash_sheet` for the second was a poor name to begin with. Name resources after what they are (`swallow`,
`anchor`) or use `for_each` when there are many similar ones.

**Real-world takeaway.** Search the whole directory (`grep -rn 'resource "local_file"'`) before adding a
resource, and give new copies a distinct name immediately. If you need many near-identical blocks, that is a
sign to reach for `for_each` over a map of designs.
