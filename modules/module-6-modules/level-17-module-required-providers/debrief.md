# Debrief — one provider version for the whole tree

Every module can declare `required_providers`. Terraform collects the declarations of the root and all its descendants,
intersects the version ranges for each provider, and installs **one** version per provider for the entire configuration.
Modules cannot bring their own copy. If the intersection is empty, init stops with "no available releases match the
given constraints" and lists every constraint that took part, which is your map of who disagrees.

That is why reusable modules should declare *lower bounds* (`>= 2.4`) for the features they need, not narrow pins like
`~> 1.4`. The root configuration, which actually owns the deployment, is the right place for the tight constraint and
the lock file `.terraform.lock.hcl` the right place for the exact version. A shared module with a narrow upper bound forces
every consumer to stay behind, and a module with a pin to an old major version blocks upgrades across the whole company.

Notice also what the fix does not touch: the module's code. Provider major versions can change resource schemas, so before
relaxing a constraint, check that the resources you use still behave the same. Here only `local_file` is used, whose
arguments are stable across both generations.

When you must support two major versions in different stacks, publish module versions: `v1` for the old provider
and `v2` for the new one, and let each root choose.

**Takeaway:** modules declare minimum provider versions, roots pin; when constraints clash, read the init error's list
of constraints and loosen the module.
