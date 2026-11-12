# Debrief - the test file is the caller

A module that declares `configuration_aliases` is saying "I need these provider configurations, you pass
them in". When you test that module, **the test file takes over the caller's job**: top-level `provider`
blocks define the configurations, and a `run` block's `providers = { ... }` argument maps them onto the
module's expected names. Without a block for each required alias, Terraform has nothing to hand over.

The error here, `Missing provider definition for local.vault`, is precise but easy to misread as being about
the module. It is about the test file. A different symptom appears if you define no provider blocks at all:
`Provider configuration not present`, which sounds like a state problem but is the same root cause.

Rules worth remembering: test-file provider blocks are file-wide, one per name-and-alias pair (duplicates are
rejected at init as `Duplicate provider block`); a run without a `providers` argument gets whichever
configuration matches by name and alias; and mapping lets one run send different aliases to different
configurations, for example pointing `vault` at a test double.

Real-world takeaway: with aliased providers (multi-region, multi-account) keep a tiny test-file preamble
that defines every alias the module needs, using test-safe settings, and map them explicitly in runs where
the mapping is part of what you are testing. It makes the module's real interface visible in the test.
