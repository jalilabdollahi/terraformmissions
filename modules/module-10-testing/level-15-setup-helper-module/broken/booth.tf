variable "manifest_path" {
  description = "Path of the JSON reel manifest."
  type        = string
}

data "local_file" "manifest" {
  filename = var.manifest_path
}

locals {
  reels = jsondecode(data.local_file.manifest.content).reels
}

output "reel_count" {
  value = length(local.reels)
}

output "total_minutes" {
  value = sum([for r in local.reels : r.minutes])
}

output "needs_intermission" {
  value = sum([for r in local.reels : r.minutes]) > 120
}
