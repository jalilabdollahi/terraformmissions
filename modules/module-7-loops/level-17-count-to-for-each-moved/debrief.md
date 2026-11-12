# Debrief - moved blocks migrate count to for_each

Switching a resource from `count` to `for_each` changes every instance address, from `[0]` to `["padstow"]`.
Terraform tracks objects by address, so it plans to destroy the old ones and create new ones. For a random name
that means new names; for a database it could mean data loss. The fix is not to avoid the refactor but to
document it: a `moved` block says "the object that used to live at this address now lives at that one".

You need one block per instance because Terraform cannot know which numeric index corresponds to which key.
Only you do: you know that `count` followed the order of `var.stations`. Get the mapping wrong
(index 0 to sennen) and the objects swap names. The validator compares each station's recorded ID with the
state after the move for exactly this reason.

## Moved blocks versus state mv

A `moved` block lives in code, is reviewed in a pull request and applies to every workspace and teammate the next
time they run `plan`. `terraform state mv` changes only the state you run it against. For shared configs,
prefer `moved`. Once everyone has applied, the blocks may stay as documentation or be removed.

## Real-world takeaway

Before any count-to-for-each conversion, run `plan` and insist that the diff is *moves*, not destroys. Write the
mapping from the old list order, apply once, and keep the new keys stable. When the new key is derived
from data, new entries then add instances without touching old ones, which the validator also tested by
planning a fourth station.
