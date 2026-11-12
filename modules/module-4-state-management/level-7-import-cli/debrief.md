# Debrief — import adopts, it does not create

`terraform import <address> <id>` links an object that already exists to a resource block in your
configuration. Terraform asks the provider to read the object by that ID and stores the result in the
state. Nothing is created or modified in the real world.

Three things make imports go wrong:

1. **The ID format is provider-specific.** For EC2 instances it is `i-0abc…`, for DNS records a
   composite string, and for `random_id` it is the URL-safe base64 value, not the hex you can read on the
   label. The provider's documentation has an "Import" section for every resource; read it first.
2. **The block must already exist.** The classic CLI import needs the destination address in the code,
   and the arguments inside the block should match the real object. If they do not, the next plan proposes
   changes or even a replacement.
3. **Import is not verified by Terraform against your intent.** If you hand it the wrong ID of an
   object that exists, it happily adopts the wrong object.

After every import, run `terraform plan`. A clean plan means the code now describes the object. Pending
changes mean you must adjust the configuration (or accept the change deliberately).

Newer Terraform also supports `import {}` blocks, which put the import into the code and into a plan you can
review. The CLI command remains useful for one-off adoption and quick experiments.
