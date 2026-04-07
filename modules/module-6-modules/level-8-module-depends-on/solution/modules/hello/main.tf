resource "local_file" "msg" {
  content  = "hello"
  filename = "${path.module}/hello.txt"
}
