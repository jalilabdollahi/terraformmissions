run "test_config" {
  command = "apply"

  # Wrong resource address — actual resource is local_file.config, not local_file.wrong_name
  override_resource {
    target = local_file.wrong_name
    values = {
      filename = "/tmp/override_config.txt"
    }
  }

  assert {
    condition     = output.config_path != ""
    error_message = "Config path should not be empty."
  }
}
