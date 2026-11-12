# Debrief — types are a contract

A variable's `type` is a promise about what callers may pass, and a `default` is just one more caller.
Terraform checks the default against the type when it loads the configuration, long before any
resource is touched. That is why `terraform validate` caught `"three"` immediately: the English word
is not something Terraform can convert into a number.

Terraform does convert between *similar* primitives. The string `"3"` becomes the number 3, and `3`
becomes `"3"`, which is why it is tempting to "fix" this by changing the type to `string`. That hides
the real problem: the value is used in arithmetic, so the declared type should say so. A `number`
constraint also gives your teammates a clear error if they pass `"three"` through a tfvars file later.

## Real-world takeaway

- Declare a type on every variable. Without one, `any` lets wrong values travel deep into a module
  before they explode.
- Put the default through the same lens as a caller: if you would not accept it on the command line,
  it does not belong in the declaration.
- `terraform validate` is cheap and needs no credentials. Run it in CI and in a pre-commit hook so
  mismatches like this one never reach a plan review.
- Descriptions (like "Front-loading washers running from 6 a.m.") are documentation for the next person; write
  them as if that person is you, at 6 a.m., in a hurry.
