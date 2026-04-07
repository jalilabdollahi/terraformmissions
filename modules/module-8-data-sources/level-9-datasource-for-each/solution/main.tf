data "local_file" "files" {
  for_each = toset(["a.txt", "b.txt"])
  filename = "${path.module}/${each.key}"
}

output "file_a_content" {
  value = data.local_file.files["a.txt"].content
}
