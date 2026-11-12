# Hollowbrook Saffron Growers' Co-op - drying team's own stack (to be retired, see ../all-in-one).

data "terraform_remote_state" "fields" {
  backend = "local"
  config = {
    path = "${path.module}/../fields/terraform.tfstate"
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
  filename = "${path.module}/../../out/drying-ledger.txt"
  content  = "team drying batch ${random_id.batch.hex} quota ${random_integer.quota.result} upstream ${data.terraform_remote_state.fields.outputs.batch}\n"
}

output "batch" {
  value = random_id.batch.hex
}
