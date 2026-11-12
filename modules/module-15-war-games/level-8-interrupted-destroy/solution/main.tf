# Halden Marquee Hire — client register and the temporary Field B marquees.
# Field B is torn down after every festival; the client register is not. Its serial is on every
# invoice and on next season's booking contracts.

resource "random_id" "client_register" {
  byte_length = 4
}

module "field_b" {
  count  = var.field_b_enabled ? 1 : 0
  source = "./modules/field_b"

  marquees = ["m1", "m2", "m3"]
}

resource "local_file" "site_plan" {
  filename = "${path.module}/plan/site-plan.txt"
  content  = <<-EOT
    register  HR-${random_id.client_register.hex}
    field b   ${join(", ", try(values(module.field_b[0].marquee_names), []))}
  EOT
}

output "register" {
  value = "HR-${random_id.client_register.hex}"
}
