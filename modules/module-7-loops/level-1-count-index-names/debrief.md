# Debrief - count gives you copies, not names

`count = 4` makes four instances of a resource block, and every instance evaluates the same arguments.
If an argument is a plain string, all four instances get exactly the same value. For most cloud
resources that is loud: the second create fails with "already exists". For `local_file` it is silent,
because writing a file twice is perfectly legal. Four resources, one file, and the only symptom is a
missing card on dinner night.

`count.index` is the thing that makes copies different. It is the zero-based position of the instance
and is only available inside a resource, data, module or similar block that sets `count`. You will use
it for names, for indexing into a list (`var.clues[count.index]`) and for deriving numbers.

## Real-world takeaway

Whenever you add `count` to a block, re-read every argument that must be unique in the real world:
names, file paths, DNS records, bucket names, port numbers. Ask "would two copies of this collide?"
If yes, that argument needs `count.index` or a value taken from a list at that index.

Also notice how the validator checked the fix: not only the four files but a plan with a five-element
list. A fix that works for exactly four hard-coded names is not a loop, and a fifth clue next season
should not need a code change.
