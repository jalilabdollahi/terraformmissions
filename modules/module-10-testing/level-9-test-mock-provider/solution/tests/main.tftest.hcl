mock_provider "local" {
  mock_resource "local_file" {
    defaults = {
      filename = "/tmp/test.txt"
    }
  }
}

run "verify_mock" {
  command = "apply"

  assert {
    condition     = output.filename == "/tmp/app.txt"
    error_message = "Filename should be /tmp/app.txt."
  }
}
