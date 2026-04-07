data "external" "info" {
  program = ["python3", "${path.module}/get_info.py"]
}

output "version" {
  value = data.external.info.result["version"]
}
