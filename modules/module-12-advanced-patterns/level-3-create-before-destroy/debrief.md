# Debrief: create_before_destroy needs unique names

By default Terraform replaces an object in the safe-for-names order: destroy the old, then create the
new. For things that must not have a gap (a load balancer, a DNS record, a sign) you can flip the order
with `create_before_destroy = true`. The price is that for a short while two objects exist at once,
and that is only possible if their identities do not collide.

Cloud APIs make this obvious: two buckets cannot share a name, so the create fails. A local file is
sneakier. Terraform happily writes the new content over the same path, and then the old object's
destroy step deletes that path. The apply reports success and the sign is gone. The plan on the next
run notices the missing file and wants to create it again.

The fix is to make the name a function of whatever forces replacement: here the film. A name with the
version, a short random suffix, or `name_prefix` for cloud resources lets the old and new objects
coexist. When you can not make names unique, accept a short gap and leave the default order.

Real-world takeaway: whenever you add `create_before_destroy`, ask "what do the old and new object
share?" and make that unique, and remember the setting spreads to dependencies as well.
