data "local_file" "readme" {
  filename = "${path.module}/readme.txt"
}

output "readme_text" {
  value = data.local_file.readme.content
}
