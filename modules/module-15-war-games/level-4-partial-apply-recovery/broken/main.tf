resource "random_string" "resource_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "resource_b" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    depends_on_a = random_string.resource_a.result
  }
}

resource "random_string" "resource_c" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    depends_on_b = random_string.resource_b.result
  }
}

output "all_three" {
  value = [
    random_string.resource_a.result,
    random_string.resource_b.result,
    random_string.resource_c.result,
  ]
}
