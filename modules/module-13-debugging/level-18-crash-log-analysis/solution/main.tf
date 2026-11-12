# Brightstone diamond mine - shaft inspection report.

data "external" "shaft_scan" {
  program = ["python3", "${path.module}/scripts/probe.py"]
}

locals {
  shaft     = data.external.shaft_scan.result.shaft
  inspector = data.external.shaft_scan.result.inspector
  readings  = jsondecode(data.external.shaft_scan.result.readings)
  deepest_m = max(values(local.readings)...)
}

resource "local_file" "inspection_report" {
  filename = "${path.module}/reports/shaft-${lower(local.shaft)}.txt"
  content  = "Shaft ${local.shaft} inspected by ${local.inspector}: deepest reading ${local.deepest_m} m\n"
}

output "deepest_m" {
  value = local.deepest_m
}
