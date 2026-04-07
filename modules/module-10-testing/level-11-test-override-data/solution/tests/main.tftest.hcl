run "test_settings" {
  command = "plan"

  override_data {
    target = data.local_file.settings
    values = {
      content = "mocked settings content"
    }
  }

  assert {
    condition     = output.settings_content != ""
    error_message = "Settings content should not be empty."
  }
}
