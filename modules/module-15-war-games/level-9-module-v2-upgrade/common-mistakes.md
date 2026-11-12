# Common mistakes

- **Applying the first clean-validating plan.** Ten objects are replaced: every helmet call-sign is re-rolled, and
  the coastguard log no longer matches the crew.
- **Staying on module v1 by pinning the old copy.** The pipeline turns green, the station never gets the v2
  fixes, and the next consumer faces the same cliff.
- **Writing moved blocks per instance for a `for_each` resource.** It works but is ten blocks long; one block per
  resource covers all instances and does not need updating when crew change.
- **Ignoring the default change.** The plan then contains five "update in place" lines; people accept them
  because they are not destructive, and the 8 hour shift goes live a month early.
- **Using `ignore_changes` on the cards.** The plan looks clean while the files stay out of step with the module.
