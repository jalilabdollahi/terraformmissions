resource "local_file" "files" {
  count    = 3
  content  = "file content ${count.index}"
  filename = "${path.module}/file-${count.index}.txt"
}

# Wrong: tries to reference files 1-3 instead of 0-2.
output "file_names" {
  value = [
    local_file.files[1].filename,
    local_file.files[2].filename,
    local_file.files[3].filename,
  ]
}
