# Hollowbrook cider co-op - cellar team's own stack (to be retired, see ../all-in-one).
# The cellar team works in a Terraform workspace per season.

data "terraform_remote_state" "press" {
  backend = "local"
  config = {
    path = "${path.module}/../press/terraform.tfstate"
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
  filename = "${path.module}/../../out/cellar-ledger.txt"
  content  = "team cellar batch ${random_id.batch.hex} quota ${random_integer.quota.result} upstream ${data.terraform_remote_state.press.outputs.batch}\n"
}

output "batch" {
  value = random_id.batch.hex
}
