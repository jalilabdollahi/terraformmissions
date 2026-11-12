# Debrief: the time provider is about stability

Terraform has no built-in "now" for resources. `timestamp()` exists but changes on every run, so a
plan using it is never clean. The `time` provider solves that with resources that record a moment
and then keep it:

- `time_static` captures the current time once (or when its `triggers` change) and keeps it in state;
- `time_offset` adds an offset to a base time (`base_rfc3339`, or "now" when you omit it) and also
  freezes the result;
- `time_sleep` and `time_rotating` are close relatives for waiting and for rotation schedules.

Two things went wrong here. The offset argument is numeric and named for its unit (`offset_days`,
`offset_hours`, ...), so `"14d"` is not a Terraform duration; durations as strings like `"72h"` belong to
`timeadd()` and `time_sleep`. And the exported attributes are the broken-down fields plus `rfc3339` and
`unix`: there is no `timestamp` attribute.

Real-world takeaway: for expiry dates, certificate-like lifetimes and rotation, anchor everything to
one frozen base (here `time_static.issued`) so that two plans an hour apart say the same thing. Using
`timestamp()` directly would make this coupon change at every apply.
