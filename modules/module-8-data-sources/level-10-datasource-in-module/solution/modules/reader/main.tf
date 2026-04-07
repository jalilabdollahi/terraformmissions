variable "filepath" {
  type = string
}

data "local_file" "file" {
  filename = var.filepath
}

output "file_content" {
  value = data.local_file.file.content
}
