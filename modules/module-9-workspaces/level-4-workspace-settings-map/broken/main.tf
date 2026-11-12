# Seafront beach hut rental board, driven by one settings map keyed by workspace.

locals {
  layouts = {
    dev = {
      huts = 4
      hours  = "10-14"
      towels  = false
    }
    prod = {
      huts = 24
      hours  = "08-18"
      towels  = true
    }
  }

  layout = local.layouts[terraform.workspace]
}

resource "local_file" "board" {
  filename = "${path.module}/out/${terraform.workspace}-board.txt"
  content  = "huts=${local.layout.huts}\nhours=${local.layout.hours}\ntowels=${local.layout.towels}\n"
}

output "huts" {
  value = local.layout.huts
}

output "hours" {
  value = local.layout.hours
}
