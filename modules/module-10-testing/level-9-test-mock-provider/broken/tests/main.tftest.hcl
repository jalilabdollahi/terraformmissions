# Mock provider declared but no mock_resource defined for local_file
mock_provider "local" {}

run "verify_mock" {
  command = "apply"

  assert {
    condition     = output.filename == "/tmp/app.txt"
    error_message = "Filename should be /tmp/app.txt."
  }
}
