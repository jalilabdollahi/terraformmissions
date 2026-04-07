locals {
  # BUG: timestamp() produces a dynamic value that cannot be serialised
  # consistently at plan time and may cause issues with jsonencode in some contexts.
  # Replace with a static map.
  config = {
    name      = "app"
    generated = timestamp()
  }
  config_json = jsonencode(local.config)
}

output "config_json" {
  value = local.config_json
}
