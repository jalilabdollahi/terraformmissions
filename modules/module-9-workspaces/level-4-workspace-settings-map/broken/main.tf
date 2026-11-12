# Riverbank farmers' market stall board, driven by one settings map keyed by workspace.

locals {
  layouts = {
    dev = {
      stalls = 4
      hours  = "10-14"
      music  = false
    }
    prod = {
      stalls = 24
      hours  = "08-18"
      music  = true
    }
  }

  layout = local.layouts[terraform.workspace]
}

resource "local_file" "board" {
  filename = "${path.module}/out/${terraform.workspace}-board.txt"
  content  = "stalls=${local.layout.stalls}\nhours=${local.layout.hours}\nmusic=${local.layout.music}\n"
}

output "stalls" {
  value = local.layout.stalls
}

output "hours" {
  value = local.layout.hours
}
