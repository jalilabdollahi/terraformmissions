# Debrief: import targets are full addresses

An `import` block has two parts: `to`, the address of a resource that exists in your configuration, and
`id`, the provider's identifier for the real object. The `to` address is an ordinary resource address, and
resources inside modules have the module path as a prefix. Terraform does not search for a resource named
`key`; it wants `module.hut.random_id.key`, with `["name"]` instance keys when the module or resource uses
`for_each` or `count`.

There is also a placement rule. Import blocks are only allowed in the root module, even when they target a resource
deep inside a child. A module you publish cannot contain its own import blocks, which makes sense: importing is
about one state, and the root module is the one that owns state.

For `random_id` the import ID is the URL-safe base64 value. That makes this lesson work without any
cloud, but the pattern is exactly the same with an `aws_s3_bucket` inside a `module "storage"`: the
`to` is `module.storage.aws_s3_bucket.this` and the `id` is the bucket name.

Real-world takeaway: build the address from the module call names in the root plus the resource address in the
child, check it against `terraform state list` for neighbours, and read the plan summary: `will be imported`.
