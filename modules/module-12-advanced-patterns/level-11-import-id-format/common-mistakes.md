# Common mistakes

- **Deleting the imports and letting Terraform create new values.** The bottle number 212 is scratched into a
  bottle's glass base; a random replacement defeats the purpose.
- **Changing `min`/`max` to make `212` fit.** The ID carries the range; the configuration must match it.
- **Typing the cork code as hex.** `random_id` imports the base64-url form; hex decodes to something else
  and triggers a replacement.
- **Removing `triggers = {}` from `time_static`.** Without it the imported attributes differ from the
  configuration and the plan wants to replace the timestamp.
