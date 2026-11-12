resource "random_id" "primary_reel" {
  byte_length = 2
}

resource "random_id" "spare_reel" {
  byte_length = 2
  provider    = random.spare
}

output "primary_reel" {
  value = random_id.primary_reel.hex
}

output "spare_reel" {
  value = random_id.spare_reel.hex
}
