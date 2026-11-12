# Kiln Street render farm: one registration file per CI agent.

variable "agents" {
  type    = set(string)
  default = ["render-01", "render-02", "render-03", "render-04"]
}

resource "local_file" "agent_card" {
  for_each = var.agents
  filename = "${path.module}/agents/${each.key}.txt"
  content  = "agent ${each.key}: 16 cores, plugin cache expected\n"
}

resource "null_resource" "farm_epoch" {
  triggers = {
    agents = join(",", sort(var.agents))
  }
}
