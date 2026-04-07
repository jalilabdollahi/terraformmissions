variable "env" {
  type = string
}

variable "output_dir" {
  type = string
}

resource "local_file" "marker" {
  content  = "deployed to: ${var.env}"
  filename = "${var.output_dir}/${var.env}-marker.txt"
}

output "marker_path" {
  value = local_file.marker.filename
}
