# Park service: each ranger leaves a JSON note; a small module reads one note.

module "north_trail" {
  source     = "./modules/ranger-notes"
  notes_file = "${path.module}/notes/north-trail.json"
}

module "south_trail" {
  source     = "./modules/ranger-notes"
  notes_file = "${path.module}/notes/south-trail.json"
}

locals {
  depths = [module.north_trail.reading.snow_cm, module.south_trail.reading.snow_cm]
}

resource "local_file" "patrol_log" {
  filename = "${path.module}/log/patrol.txt"
  content  = <<-EOT
    North trail (${module.north_trail.reading.ranger}): ${module.north_trail.reading.snow_cm} cm
    South trail (${module.south_trail.reading.ranger}): ${module.south_trail.reading.snow_cm} cm
  EOT
}

output "lowest_snow_cm" {
  value = min(local.depths...)
}

output "open_trails" {
  value = [for name, r in { north = module.north_trail.reading, south = module.south_trail.reading } : name if r.trail_open]
}
