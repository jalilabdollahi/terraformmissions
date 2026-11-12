# Ember Row glassworks: kiln firing logs per season (workspace).

locals {
  firings = {
    winter = 6
    summer = 14
  }
}

resource "local_file" "kiln_log" {
  filename = "${path.module}/out/${terraform.workspace}-kiln.txt"
  content  = "season=${terraform.workspace}\nfirings=${local.firings[terraform.workspace]}\n"
}

resource "local_file" "annealer_log" {
  filename = "${path.module}/out/${terraform.workspace}-annealer.txt"
  content  = "annealer cycles for ${terraform.workspace}: ${local.firings[terraform.workspace] * 2}\n"
}
