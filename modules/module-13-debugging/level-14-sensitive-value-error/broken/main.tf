variable "service_tokens" {
  type      = map(string)
  sensitive = true
  default = {
    web    = "token-web-001"
    api    = "token-api-002"
    worker = "token-worker-003"
  }
}

# Bug: for_each keys come from a sensitive variable — Terraform rejects this
resource "local_file" "service_config" {
  for_each = var.service_tokens

  content         = "service=${each.key}"
  filename        = "${path.module}/service-${each.key}.txt"
  file_permission = "0600"
}
