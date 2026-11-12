variable "acts" {
  type = list(object({
    title   = string
    minutes = number
  }))
  default = [
    { title = "Newsact", minutes = 10 },
    { title = "Warm-up", minutes = 8 },
    { title = "Headliner", minutes = 87 },
  ]
}

resource "local_file" "lineup" {
  filename = "${path.module}/lineup.json"
  content  = jsonencode({ acts = var.acts })
}

output "lineup_path" {
  value = local_file.lineup.filename
}
