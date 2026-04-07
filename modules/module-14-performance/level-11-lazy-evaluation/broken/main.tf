# BUG: The template path is wrong.
# The template file lives at templates/service.tpl
# but this code points to templates/configs/service.tpl (extra subdirectory that doesn't exist).
resource "local_file" "service_configs" {
  for_each = var.services
  filename = "${path.module}/output/${each.key}.conf"
  content  = templatefile("${path.module}/templates/configs/service.tpl", {
    service_name = each.key
    port         = each.value.port
    environment  = each.value.env
  })
}

output "config_count" {
  value = length(local_file.service_configs)
}
