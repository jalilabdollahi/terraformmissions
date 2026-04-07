resource "local_file" "test" {
  content  = "lock conflict test"
  filename = "${path.module}/test.txt"
}
