# Debrief — null is a value, not an absence

In Terraform, leaving out an argument and passing `null` look similar but behave differently for module
variables. Omitting it makes Terraform use the variable's `default`. Passing `null` — which is exactly
what happens when you forward an optional root variable whose own default is `null` — sets the variable
to null, and the default is ignored. Everything downstream that cannot cope with null then fails, as the
interpolation did here.

`nullable = false` changes that contract. For a non-nullable variable, Terraform replaces a `null`
argument with the default value, and rejects `null` outright if there is no default. It exists in
Terraform since 1.1 and is the right tool for "the caller may pass nothing, and I always want a real value".

Alternatives and their costs:
- `coalesce(var.retention_override, 30)` in the caller duplicates the default in every module call and
  silently diverges from the module's own idea of "default".
- `try(..., 30)` hides other kinds of errors.
- Leaving `nullable = true` is correct when null *means something* (for example "no encryption key").

## Real-world takeaway

When you build a module, decide per input whether null is a meaningful value. If it is not, say so with
`nullable = false`; callers that forward optional values from their own variables will then Just Work,
and a root with `default = null` stops being a trap. Put the default in exactly one place: the module that
owns the setting.
