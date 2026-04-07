provider "local" {}

run "check_report" {
  command = "apply"

  assert {
    condition     = output.report_path != ""
    error_message = "Report path should not be empty."
  }
}
