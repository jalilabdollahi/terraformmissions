# Port of Karaburun: cargo manifest tracking.
# The state of this workspace has been applied several times. Customs wants
# its serial, lineage and the container seal value.

variable "revision" {
  description = "Manifest revision, bumped every time the manifest is re-filed."
  type        = number
  default     = 3
}

resource "terraform_data" "cargo_manifest" {
  input = {
    vessel   = random_pet.vessel.id
    revision = var.revision
  }
}

resource "random_pet" "vessel" {
  length = 2
  prefix = "mv"
}

resource "random_id" "container_seal" {
  byte_length = 5
}
