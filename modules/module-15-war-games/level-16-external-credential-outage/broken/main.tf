# Brannock Quay fish market - nightly landing-permit pipeline.
# 1. look up the vessel's landing quota in the fisheries registry (external data source)
# 2. issue the vessel key
# 3. stamp the permit through the registry (local-exec), then publish the quota sheet

variable "vessel" {
  type    = string
  default = "BRK-114 Marguerite"
}

variable "region" {
  type    = string
  default = "north_sea"
}

data "external" "quota" {
  program = ["python3", "${path.module}/bin/quota_lookup.py"]
  query = {
    region = var.region
    vessel = var.vessel
  }
}

resource "random_id" "vessel_key" {
  byte_length = 6
}

resource "terraform_data" "permit_stamp" {
  input = data.external.quota.result.tonnes

  provisioner "local-exec" {
    command = "python3 ${path.module}/bin/stamp.py"
    environment = {
      QUOTA_REGION = var.region
      VESSEL       = var.vessel
      VESSEL_KEY   = random_id.vessel_key.hex
      QUOTA_TONNES = data.external.quota.result.tonnes
    }
  }
}

resource "local_file" "quota_sheet" {
  filename = "${path.module}/out/quota-sheet.txt"
  content  = "vessel ${var.vessel} region ${data.external.quota.result.region} licence ${data.external.quota.result.licence} tonnes ${data.external.quota.result.tonnes} key ${random_id.vessel_key.hex}\n"
}

output "quota_tonnes" {
  value = data.external.quota.result.tonnes
}
