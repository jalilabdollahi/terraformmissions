# Hollowbrook Saffron Growers' Co-op - packing team's own stack (to be retired, see ../all-in-one).
# The packing team works in a Terraform workspace per season.

data "terraform_remote_state" "drying" {
  backend = "local"
  config = {
    path = "${path.module}/../drying/terraform.tfstate"
  }
}

resource "random_id" "batch" {
  byte_length = 5
}

resource "random_integer" "quota" {
  min = 40
  max = 90
}

resource "local_file" "ledger" {
  filename = "${path.module}/../../out/packing-ledger.txt"
  content  = "team packing batch ${random_id.batch.hex} quota ${random_integer.quota.result} upstream ${data.terraform_remote_state.drying.outputs.batch}\n"
}

output "batch" {
  value = random_id.batch.hex
}
