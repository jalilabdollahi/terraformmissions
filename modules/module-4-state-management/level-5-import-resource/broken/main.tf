# The validator will create a file at /tmp/tm_existing.txt, then attempt to
# import it using the filename declared here.
# BUG: the filename doesn't match the file that will be imported.

resource "local_file" "existing" {
  content  = "pre-existing file content"
  filename = "/tmp/tm_wrong_path.txt"
}
