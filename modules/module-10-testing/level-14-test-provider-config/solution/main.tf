resource "local_file" "report" {
  content  = "report data"
  filename = "${path.module}/report.txt"
}

output "report_path" {
  value = local_file.report.filename
}
