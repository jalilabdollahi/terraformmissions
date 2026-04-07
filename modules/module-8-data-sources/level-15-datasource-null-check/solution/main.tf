data "local_file" "maybe" {
  filename = "${path.module}/maybe.txt"
}

output "file_content" {
  value = try(data.local_file.maybe.content, "default")
}
