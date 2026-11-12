# Canal authority: each lock keeper leaves a JSON note; a small module reads one note.

module "north_lock" {
  source     = "./modules/lock-notes"
  notes_file = "${path.module}/notes/north-lock.json"
}

module "south_lock" {
  source     = "./modules/lock-notes"
  notes_file = "${path.module}/notes/south-lock.json"
}

locals {
  levels = [module.north_lock.level_cm, module.south_lock.water_level]
}

resource "local_file" "watch_log" {
  filename = "${path.module}/log/watch.txt"
  content  = <<-EOT
    North lock (${module.north_lock.keeper}): ${module.north_lock.level_cm} cm
    South lock (${module.south_lock.keeper}): ${module.south_lock.water_level} cm
  EOT
}

output "lowest_level_cm" {
  value = min(local.levels...)
}

output "open_gates" {
  value = [for name, r in { north = module.north_lock.reading, south = module.south_lock.reading } : name if r.gates_open]
}
