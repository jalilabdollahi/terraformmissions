# Rustfield scrapyard: shift planning. The yard identity now lives in core/.

data "terraform_remote_state" "core" {
  backend = "local"
  config = {
    path = "${path.module}/core/terraform.tfstate"
  }
}

resource "local_file" "crane_roster" {
  filename = "${path.module}/cranes/roster.txt"
  content  = "${data.terraform_remote_state.core.outputs.yard_name} runs ${data.terraform_remote_state.core.outputs.gate_count} gates; cranes 1-6 on days\n"
}

output "yard_name" {
  value = data.terraform_remote_state.core.outputs.yard_name
}
