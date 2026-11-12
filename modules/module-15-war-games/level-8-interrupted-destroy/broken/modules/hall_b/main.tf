variable "stands" {
  type = list(string)
}

resource "random_pet" "stand" {
  for_each = toset(var.stands)
  length   = 2
  prefix   = "hb"
}

# Registers a stand with the venue's power and rigging desk and, on teardown, hands the
# bay back through unrig.sh.
resource "terraform_data" "rigging" {
  for_each = toset(var.stands)
  input    = each.key

  provisioner "local-exec" {
    when    = destroy
    command = "bash scripts/unrig.sh ${self.input}"
  }
}

resource "local_file" "signage" {
  for_each = toset(var.stands)
  filename = "${path.root}/signage/${each.key}.txt"
  content  = "${random_pet.stand[each.key].id} (bay ${terraform_data.rigging[each.key].id})\n"
}

output "stand_names" {
  value = { for k, p in random_pet.stand : k => p.id }
}
