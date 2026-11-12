# Hammerstone Auction House: lot catalogue tracking.
# The state of this workspace has been applied several times. The authentication desk wants
# its serial, lineage and the lot seal value.

variable "revision" {
  description = "Catalogue revision, bumped every time the catalogue is re-issued."
  type        = number
  default     = 3
}

resource "terraform_data" "lot_catalogue" {
  input = {
    artwork  = random_pet.artwork.id
    revision = var.revision
  }
}

resource "random_pet" "artwork" {
  length = 2
  prefix = "art"
}

resource "random_id" "lot_seal" {
  byte_length = 5
}
