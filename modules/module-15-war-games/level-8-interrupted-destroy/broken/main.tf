# Halden Trade Fair — exhibitor register and the temporary Hall B stands.
# Hall B is torn down after every fair; the exhibitor register is not. Its serial is on every
# invoice and on next year's early-bird contracts.

resource "random_id" "exhibitor_register" {
  byte_length = 4
}

module "hall_b" {
  count  = var.hall_b_enabled ? 1 : 0
  source = "./modules/hall_b"

  stands = ["s1", "s2", "s3"]
}

resource "local_file" "floor_plan" {
  filename = "${path.module}/plan/floor-plan.txt"
  content  = <<-EOT
    register  HR-${random_id.exhibitor_register.hex}
    hall b    ${join(", ", values(module.hall_b[0].stand_names))}
  EOT
}

output "register" {
  value = "HR-${random_id.exhibitor_register.hex}"
}
