locals {
  workspace_config = {
    default    = { env = "development", replicas = 1 }
    staging    = { env = "staging",     replicas = 1 }
    production = { env = "production",  replicas = 3 }
  }
}

resource "local_file" "env_config" {
  for_each = local.workspace_config[terraform.workspace] != null ? { this = local.workspace_config[terraform.workspace] } : {}
  content  = "env=${each.value.env} replicas=${each.value.replicas}"
  filename = "${path.module}/${terraform.workspace}.conf"
}
