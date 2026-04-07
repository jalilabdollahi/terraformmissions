# The workspace_config map is missing the "default" key.
# Running terraform plan in the default workspace will fail because the key is absent.
# Fix: add a "default" entry to the workspace_config map.

locals {
  workspace_config = {
    staging    = { env = "staging",    replicas = 1 }
    production = { env = "production", replicas = 3 }
  }
}

resource "local_file" "env_config" {
  for_each = local.workspace_config[terraform.workspace] != null ? { this = local.workspace_config[terraform.workspace] } : {}
  content  = "env=${each.value.env} replicas=${each.value.replicas}"
  filename = "${path.module}/${terraform.workspace}.conf"
}
