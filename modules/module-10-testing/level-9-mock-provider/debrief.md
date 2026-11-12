# Debrief - mocks replace the provider, not the schema

`mock_provider "random" {}` tells `terraform test` to stand in for the real provider: no plugin binary
does any work, and every computed attribute is filled by Terraform itself. Without help it fills strings
with random-looking text and numbers with 0 or similar, which is fine for "does my code wire things up?" but
useless for exact assertions. That is what `mock_resource` and its `defaults` object are for: they pin
specific computed attributes of a resource type to values you choose.

This level has two traps. The first is shape: `defaults` is an attribute holding an object, and the
resource's own attributes are not valid directly inside the block. The second is more dangerous because it
is silent. A key in `defaults` that does not exist in the schema is ignored, so a typo does not break
anything loudly; the mock just does not do what you wanted, and the symptom is a mysterious value in an
assertion. When a mocked value looks random, suspect the key name before anything else.

Mocks also make tests cheap. Because nothing real is created, apply-mode runs finish immediately, even for
resources that normally take minutes or cost money, and you can run the same suite in CI without
credentials.

Real-world takeaway: mock for logic, not for provider behaviour. Pin only the attributes your
code reads, double-check their names against the schema, and keep a few real-provider runs elsewhere to
catch the things a mock can never know.
