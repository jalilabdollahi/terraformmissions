data "external" "info" {
  program = ["python3", "-c", "import json; print(json.dumps({'key': 'value'}))"]
}

output "key" {
  value = data.external.info.result["key"]
}
