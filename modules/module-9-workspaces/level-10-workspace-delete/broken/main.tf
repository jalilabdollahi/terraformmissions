# Willow Bend handmade paper mill: pulp recipe batch sheet per workspace.

locals {
  paper_recipe = {
    keep  = "cotton rag 60 / linen 30 / hemp 10"
    trial = "bamboo 50 / banana fibre 40 / flax 10"
  }
}

resource "local_file" "batch" {
  filename = "${path.module}/out/${terraform.workspace}-batch.txt"
  content  = "Recipe for ${terraform.workspace}: ${local.paper_recipe[terraform.workspace]}\n"
}
