# Willow Bend soap-making workshop: recipe batch sheet per workspace.

locals {
  soap_recipe = {
    keep  = "olive oil 60 / coconut oil 30 / shea 10"
    trial = "avocado 50 / palm kernel 40 / castor 10"
  }
}

resource "local_file" "batch" {
  filename = "${path.module}/out/${terraform.workspace}-batch.txt"
  content  = "Recipe for ${terraform.workspace}: ${local.soap_recipe[terraform.workspace]}\n"
}
