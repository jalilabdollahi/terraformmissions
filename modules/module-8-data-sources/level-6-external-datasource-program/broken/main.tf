# The program "nonexistent_binary" does not exist.
# Fix: replace with a valid program that outputs JSON.

data "external" "info" {
  program = ["nonexistent_binary"]
}

output "key" {
  value = data.external.info.result["key"]
}
