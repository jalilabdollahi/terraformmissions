# Pigeon post: one perch card per relay station, station lists per workspace.

locals {
  stations = {
    pilot   = ["elm-hill", "dovecote"]
    network = ["elm-hill", "dovecote", "mill-pond", "ash-cross", "dovecote"]
  }
  active = local.stations[terraform.workspace]
}

resource "local_file" "perch" {
  for_each = local.active
  filename = "${path.module}/out/${terraform.workspace}/${each.key}.txt"
  content  = "Perch card for ${each.key} (${terraform.workspace} network)\n"
}

output "station_count" {
  value = length(local_file.perch)
}
