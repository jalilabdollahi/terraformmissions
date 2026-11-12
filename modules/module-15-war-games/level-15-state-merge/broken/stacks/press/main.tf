# Hollowbrook cider co-op - press team's own stack (to be retired, see ../all-in-one).

data "terraform_remote_state" "orchard" {
  backend = "local"
  config = {
    path = "${path.module}/../orchard/terraform.tfstate"
  }
}

resource "random_id" "batch" {
  byte_length = 5
}

resource "random_integer" "quota" {
  min = 50
  max = 120
}

resource "local_file" "ledger" {
  filename = "${path.module}/../../out/press-ledger.txt"
  content  = "team press batch ${random_id.batch.hex} quota ${random_integer.quota.result} upstream ${data.terraform_remote_state.orchard.outputs.batch}\n"
}

output "batch" {
  value = random_id.batch.hex
}
