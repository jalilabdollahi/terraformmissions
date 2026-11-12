# Debrief — a source string is an address, not a path

Terraform decides how to fetch a module purely from the *shape* of the `source` string. Anything that begins
with `./` or `../` is a local directory, resolved relative to the module that contains the call. Everything
else is handed to the registry, Git, S3 or another fetcher. That is why `"modules/grading"` produced a
confusing registry error instead of "file not found": Terraform never considered it a path at all.

Two details trip people up in real repositories. First, the path is relative to the calling module, so a call
from `modules/a/main.tf` to a sibling is `../b`, not `./modules/b`. Second, module sources are resolved by
`terraform init` and cached in `.terraform/modules/modules.json`; editing a `source` and running `plan`
without init gives the familiar "Module not installed" error.

Local modules are copied by reference, not downloaded: edits to the folder are picked up immediately by the
next plan, with no re-init needed unless the source string changes. That is what makes them ideal for
splitting a growing root configuration into pieces before you are ready to publish anything.

**Takeaway:** when init says a module source is invalid, read the address as Terraform sees it. Start local
paths with `./` or `../`, double-check the real directory name with `ls`, and re-init after any source change.
