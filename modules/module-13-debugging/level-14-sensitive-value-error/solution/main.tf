variable "service_tokens" {
  type      = map(string)
  sensitive = true
  default = {
    web    = "token-web-001"
    api    = "token-api-002"
    worker = "token-worker-003"
  }
}

# Fixed: wrap with nonsensitive() so keys can be used in for_each
# The keys (service names) are not themselves sensitive; only the values (tokens) are.
resource "local_file" "service_config" {
  for_each = nonsensitive(var.service_tokens)

  content         = "service=${each.key}"
  filename        = "${path.module}/service-${each.key}.txt"
  file_permission = "0600"
}
