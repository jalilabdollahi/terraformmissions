# Willow Bend bonsai nursery: soil batch sheet per workspace.

locals {
  soil_mix = {
    keep  = "akadama 60 / pumice 30 / lava 10"
    trial = "peat 50 / bark 40 / perlite 10"
  }
}

resource "local_file" "batch" {
  filename = "${path.module}/out/${terraform.workspace}-batch.txt"
  content  = "Soil mix for ${terraform.workspace}: ${local.soil_mix[terraform.workspace]}\n"
}
