variable "reels" {
  type = list(object({
    title   = string
    minutes = number
  }))
  default = [
    { title = "Newsreel", minutes = 10 },
    { title = "Cartoon", minutes = 8 },
    { title = "Feature", minutes = 87 },
  ]
}

resource "local_file" "manifest" {
  filename = "${path.module}/manifest.json"
  content  = jsonencode({ reels = var.reels })
}

output "manifest_path" {
  value = local_file.manifest.filename
}
