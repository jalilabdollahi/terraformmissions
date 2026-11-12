variable "hut" {
  type = string
}

resource "random_integer" "soup" {
  min = 100
  max = 999
  keepers = {
    hut = var.hut
  }
}

output "soup_batch" {
  value = random_integer.soup.result
}
