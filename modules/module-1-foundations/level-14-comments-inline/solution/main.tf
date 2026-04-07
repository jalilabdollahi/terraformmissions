resource "local_file" "notes" {
  content  = "deployment notes" # TODO: expand this
  filename = "${path.module}/notes.txt"
}
