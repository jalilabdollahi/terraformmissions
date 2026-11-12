# Tinsel Lane Christmas decorations factory: bauble batch logs per season (workspace).

locals {
  batches = {
    winter = 6
    summer = 14
  }
}

resource "local_file" "bauble_log" {
  filename = "${path.module}/out/${terraform.workspace}-baubles.txt"
  content  = "season=${terraform.workspace}\nbatches=${local.batches[terraform.workspace]}\n"
}

resource "local_file" "tinsel_log" {
  filename = "${path.module}/out/${terraform.workspace}-tinsel.txt"
  content  = "tinsel runs for ${terraform.workspace}: ${local.batches[terraform.workspace] * 2}\n"
}
