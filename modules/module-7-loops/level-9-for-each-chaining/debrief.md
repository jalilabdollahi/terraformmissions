# Debrief - for_each over another resource

A resource that uses `for_each` is, from the outside, a map: its keys are the keys you iterated and its
values are the full resource instances. That makes it a legal `for_each` argument for another resource.
This is called **chaining**, and it is the cleanest way to say "one of these for every one of those".

Inside the chained resource `each.key` is the original key (the cadet name) and `each.value` is the
upstream instance, so `each.value.id` reads that cadet's own random_pet. No index arithmetic, and no
need to repeat the list of cadets and hope both resources stay in step.

## What you get for free

- **One source of truth.** Add a name to `var.cadets` and both the call sign and the card appear. Remove
  it and both go. The validator proves exactly that with a plan.
- **Dependency tracking.** `for_each = random_pet.callsign` gives Terraform an implicit dependency. Cards
  are created after the pets.
- **Stable keys.** Because the keys are names rather than positions, no unrelated instance is replaced
  when the list changes.

## A caveat

Chaining requires the keys of the upstream resource to be known at plan time. They are here, because
they come from a variable. If the *upstream* keys were derived from something only known after apply, you
would hit the "unknown for_each keys" error - the lesson of a later mission.

## Real-world takeaway

Build a per-thing chain once (certificate -> DNS validation record -> load-balancer listener) and let the
data drive it, instead of copying `count` boilerplate at every layer.
