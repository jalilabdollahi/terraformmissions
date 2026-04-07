resource "local_file" "greeting" {
  content  = "hello world"
  filename = "${path.module}/greeting.txt"
}

output "filename" {
  value = local_file.greeting.filename
}
