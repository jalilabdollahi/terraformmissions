resource "local_file" "debug_test" {
  content  = "debug log test"
  filename = "${path.module}/debug.txt"
}
