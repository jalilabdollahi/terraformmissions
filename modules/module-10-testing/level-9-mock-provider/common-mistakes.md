# Common mistakes

- **Removing the mock and asserting on the real random output.** The values are not predictable, so the exact-value assertions cannot pass.
- **Deleting `mock_resource "random_integer"`.** The provider then invents the zone number; you must pin `result`.
- **Changing the assertions to the values the broken mock produces.** Random values change every run, and the validator requires DW-AB12CD34 and zone-4 literally.
- **Putting the defaults at the top of the file outside `mock_provider`.** `defaults` is only valid inside a `mock_resource` (or `mock_data`) block.
