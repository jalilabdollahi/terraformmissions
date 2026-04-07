resource "local_file" "init_test" {
  content  = "init failure test"
  filename = "${path.module}/init_test.txt"
}
