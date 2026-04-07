resource "local_file" "app" {
  content  = "mock content"
  filename = "/tmp/app.txt"
}

output "filename" {
  value = local_file.app.filename
}
