# Debrief - reading a crash like a maintainer

Terraform normally reports problems as tidy `Error:` blocks. When a *provider plugin* panics, the output looks different: a Go stack trace
(`panic: ...`, `goroutine N [running]`) followed by "Plugin did not respond" or "Terraform crashed!". Newer versions also
write a `crash.log`. It looks frightening but follows a pattern, and you can extract the answer in a minute:

1. **Find the panic line.** It states the *kind* of failure: here a type assertion failed (`interface conversion`), so a value had a shape the code did not expect.
2. **Read the top of the stack.** The first frame inside the provider's package names the function: `externalDataSource.Read` tells you which
   data source or resource type, and which operation (Read, Plan, Apply).
3. **Read the lines before the panic.** The trace log shows what the provider was doing: which program, which request, which key.
4. **Map it back to your config.** The `with data.external.shaft_scan` block in the wrapping error is the address; the key name tells
   you which attribute to inspect.

A provider crash is a bug (the provider should have reported a clean error), and you can report it with the trace, but your workaround
is usually in your own configuration: avoid the input shape that triggers it. Here, by sending a string instead of an object and decoding it on the
Terraform side.

Habits: capture `TF_LOG=TRACE TF_LOG_PATH=...` when reproducing, keep the provider version from the trace, search the provider's issue tracker for the panic text, and never paste a
crash log into a public ticket without reading it first: values from your configuration can end up in it.
