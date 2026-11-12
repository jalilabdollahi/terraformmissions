# Common mistakes

- **Using `optional(number)` without a default.** The attribute becomes `null` and the rota text shows `@k`.
- **Making `skill` optional as well.** Queues without a skill would be accepted; the mission keeps it mandatory.
- **Changing the type to `any`.** The error disappears but so do the defaults: missing attributes then break the expression
  `s.bitrate_kbps` instead.
- **Filling the gaps in the root with `merge()`.** It works for these three queues but every other caller of the module
  would have to repeat it; defaults belong in the module's interface.
