# Debrief — generated config is a draft, not a deliverable

Writing resource blocks for dozens of existing objects by hand is slow and error-prone. Since
Terraform 1.5, `terraform plan -generate-config-out=<file>` reads every `import` block that has no
matching resource, asks the provider to read the real object, and writes a first draft of the config.

That draft is deliberately *complete*: it spells out every attribute, including optional ones set to
`null` and ones that merely repeat provider defaults. It is valid and already produces a clean plan, but
it is noisy, it carries a "generated" banner and it sits in a file nobody intended to keep. Typical
cleanup:

- move the blocks to the file where they belong and delete the draft file;
- delete `= null` lines and attributes that equal the defaults (keep the ones that document intent);
- rename or parameterise values, replacing hard-coded values with variables or references;
- check for secrets: generated configs can contain sensitive values in clear text.

Two further facts are worth remembering. The feature is still marked experimental, so the output
format may change, and it cannot generate configuration for every resource type (some resources set
computed values that cannot be written back). Always finish with `terraform plan`: a clean plan
proves the cleaned config still describes the live object, and the "N to import" line tells you the
adoption is about to happen on the next `apply`.
