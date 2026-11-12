# Watering cron job for the Dome 3 greenhouse. Terraform writes the shell
# script; the controller's cron runs it. The shell expands HOME and
# PUMP_SECONDS at run time, but Terraform fills in the bay name at plan time.
variable "bay" {
  type    = string
  default = "tomato-bay"
}

resource "local_file" "water_script" {
  filename        = "${path.module}/dome3/water.sh"
  file_permission = "0755"
  content         = <<-EOT
    #!/usr/bin/env bash
    # Watering routine for ${var.bay}
    PUMP_LOG="$${HOME}/greenhouse/pump.log"
    sleep "$${PUMP_SECONDS:-30}"
    echo "watered ${var.bay}" >> "$PUMP_LOG"
  EOT
}

output "script_path" {
  value = local_file.water_script.filename
}
