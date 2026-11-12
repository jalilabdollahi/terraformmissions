# Port Calder pilotage notice generator.

resource "local_file" "notice" {
  filename = "${path.module}/notice/pilotage.txt"
  content = join("\n", [
    "PILOTAGE NOTICE - ${upper(var.port_name)}",
    "Berths: ${var.berth_count}",
    "Entry windows: ${join(" / ", var.tide_windows)}",
    "Pilot compulsory over 40 m: ${var.pilot_required ? "YES" : "no"}",
    "",
  ])
}

output "port" {
  value = var.port_name
}

output "berths" {
  value = var.berth_count
}

output "windows" {
  value = var.tide_windows
}

output "pilot_required" {
  value = var.pilot_required
}
