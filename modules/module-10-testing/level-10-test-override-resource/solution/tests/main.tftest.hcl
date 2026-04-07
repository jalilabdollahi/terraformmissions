run "test_config" {
  command = "apply"

  override_resource {
    target = local_file.config
    values = {
      filename = "/tmp/override_config.txt"
    }
  }

  assert {
    condition     = output.config_path != ""
    error_message = "Config path should not be empty."
  }
}
