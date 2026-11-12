variable "streams" {
  description = "Streams to broadcast; only genre is required"
  default = {
    late_show = { genre = "jazz" }
    morning   = { genre = "talk", bitrate_kbps = 64 }
    kids      = { genre = "stories", jingle = false }
  }
}

module "schedule" {
  source = "./modules/schedule"

  streams = var.streams
}

resource "local_file" "lineup" {
  filename = "${path.module}/radio/lineup.txt"
  content  = "${join("\n", module.schedule.lineup)}\n"
}

output "lineup" {
  value = module.schedule.lineup
}
