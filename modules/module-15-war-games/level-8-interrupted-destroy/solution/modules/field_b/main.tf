variable "marquees" {
  type = list(string)
}

resource "random_pet" "marquee" {
  for_each = toset(var.marquees)
  length   = 2
  prefix   = "hb"
}

# Registers a marquee with the site's power and rigging desk and, on teardown, hands the
# rig back through unrig.sh.
resource "terraform_data" "rigging" {
  for_each = toset(var.marquees)
  input    = each.key

  provisioner "local-exec" {
    when    = destroy
    command = "bash scripts/unrig.sh ${self.input}"
  }
}

resource "local_file" "tags" {
  for_each = toset(var.marquees)
  filename = "${path.root}/tags/${each.key}.txt"
  content  = "${random_pet.marquee[each.key].id} (rig ${terraform_data.rigging[each.key].id})\n"
}

output "marquee_names" {
  value = { for k, p in random_pet.marquee : k => p.id }
}
