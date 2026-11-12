# Pinewood Ferris Wheel Hire settings, loaded from env/<workspace>.yaml.

locals {
  settings = file("${path.module}/env/${terraform.workspace}.yaml")
}

resource "local_file" "wheel" {
  filename = "${path.module}/out/${terraform.workspace}-wheel.conf"
  content  = "spin_seconds=${local.settings.spin_seconds}\npod_count=${local.settings.pod_count}\n"
}

output "rotation" {
  value = local.settings.spin_seconds
}

output "pod_count" {
  value = local.settings.pod_count
}
