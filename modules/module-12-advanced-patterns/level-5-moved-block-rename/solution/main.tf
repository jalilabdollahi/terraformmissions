resource "local_file" "new" {
  content  = "renamed resource"
  filename = "${path.module}/output.txt"
}

moved {
  from = local_file.old
  to   = local_file.new
}
