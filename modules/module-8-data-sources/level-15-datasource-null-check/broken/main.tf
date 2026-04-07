# If "maybe.txt" does not exist, the plan fails with a hard error.
# Fix: wrap the output value in try() to provide a default.

data "local_file" "maybe" {
  filename = "${path.module}/maybe.txt"
}

output "file_content" {
  value = data.local_file.maybe.content
}
