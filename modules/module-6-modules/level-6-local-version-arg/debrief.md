# Debrief — only registries have versions

A module call has two ways to say *what* to load: `source` for the location and `version` for the release.
The second only exists when the source is a **registry**: public (`terraform-aws-modules/vpc/aws`) or private.
A registry keeps a list of published releases and Terraform picks the newest one that satisfies your constraint.

A local path has no list of releases. It is the directory as it exists on disk, at the commit you have checked out.
So `version = "~> 1.2"` is not just useless there, it would be misleading, suggesting that the module is
pinned when in reality it would change with every `git pull`. Terraform therefore refuses it outright, and the same
holds for Git, HTTP and other raw sources, where the pin lives inside the address itself: `?ref=v1.2.0`.

This is a useful mental model for repositories with shared modules. If many stacks call `./modules/folds`, they all
see the same code at once; changing it is a deployment of every consumer. When that is too risky, version the module
properly: tag the repository and use `git::https://...//modules/folds?ref=v1.2.0`, or publish it to a registry and
use `version`.

**Takeaway:** use `version` only with registry sources; for local modules the repository revision is the version;
for Git sources pin with `?ref=`.
