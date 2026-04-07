locals {
  app_name    = "backend"
  environment = "staging"
}

resource "local_file" "config" {
  content  = "app=${local.app_name} env=${local.environment}"
  filename = "${path.module}/service.conf"
}
