# Bug: timestamp() returns a new value every time terraform plan runs,
# causing a perpetual diff — the file content will always appear changed.
resource "local_file" "log_marker" {
  content  = "Generated at: ${timestamp()}"
  filename = "${path.module}/marker.txt"
}
