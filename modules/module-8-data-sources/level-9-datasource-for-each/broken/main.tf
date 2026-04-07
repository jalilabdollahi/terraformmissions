# for_each creates instances keyed by the set values ("a.txt", "b.txt").
# The output is missing the key — you must reference data.local_file.files["a.txt"].content.
# Fix: add the key ["a.txt"] to the reference.

data "local_file" "files" {
  for_each = toset(["a.txt", "b.txt"])
  filename = "${path.module}/${each.key}"
}

output "file_a_content" {
  value = data.local_file.files.content
}
