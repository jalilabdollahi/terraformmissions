# Common Mistakes

- **Doing the rename and module move separately** — requires two applies and double the moved blocks.
- **Wrong `from` address** — must be the exact old address as it was in state before the refactor.
- **Wrong `to` address** — module prefix must match the module block name exactly.
- **Removing moved blocks before all workspaces are updated** — keeps them until full rollout.