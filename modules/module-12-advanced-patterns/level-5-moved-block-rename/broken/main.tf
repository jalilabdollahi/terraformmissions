resource "local_file" "new" {
  content  = "renamed resource"
  filename = "${path.module}/output.txt"
}

# Bug: from/to are swapped — should be from=old, to=new
moved {
  from = local_file.new
  to   = local_file.old
}
