run "test_settings" {
  command = "plan"

  # Wrong: actual data source is data.local_file.settings, not data.local_file.wrong
  override_data {
    target = data.local_file.wrong
    values = {
      content = "mocked settings content"
    }
  }

  assert {
    condition     = output.settings_content != ""
    error_message = "Settings content should not be empty."
  }
}
