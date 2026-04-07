variable "filename" {
  type    = string
  default = "output.txt"
}

resource "local_file" "out" {
  content  = "data"
  filename = "${path.module}/${var.filename}"
}

output "file_path" {
  value = local_file.out.filename
}
