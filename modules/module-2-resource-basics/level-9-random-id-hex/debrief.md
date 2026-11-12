# Debrief: one random value, several spellings

`random_id` generates `byte_length` random bytes once and exposes them in several encodings:
`hex` (2 characters per byte), `b64_std` and `b64_url` (about 4 characters per 3 bytes, with `+/` or
`-_`), and `dec` (a big decimal number). The encoding you choose decides which characters your tag can
contain, and the number of bytes decides how long it is. For N hex characters you need N/2 bytes;
an odd length means you either round up and use `substr`, or accept the extra byte.

The two settings are easy to mix up when you copy code: here `byte_length = 12` looked right because
the requirement said "12", but the unit is bytes, not characters. A quick `terraform console` session
(`random_id.batch.hex`) shows the actual value in seconds.

Like other random resources, the id is stable after creation. `random_id` is the usual tool for
unique suffixes on globally named cloud objects (storage buckets, DNS labels). Use `keepers` to
regenerate the suffix when one of its inputs changes. Also remember that random suffixes make plans
non-obvious to humans, so keep the readable part of the name in a prefix.
