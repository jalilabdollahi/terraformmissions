resource "local_file" "old_name" {
  content  = "managed by terraform"
  filename = "${path.module}/managed.txt"
}
