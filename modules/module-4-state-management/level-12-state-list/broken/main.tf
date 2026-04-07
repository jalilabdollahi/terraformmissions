# Five random resources, but one is named "count" — a Terraform meta-argument keyword.
# BUG: resource name "count" conflicts with the meta-argument keyword

resource "random_string" "alpha" {
  length  = 6
  special = false
}

resource "random_string" "beta" {
  length  = 6
  special = false
}

resource "random_string" "gamma" {
  length  = 6
  special = false
}

resource "random_string" "delta" {
  length  = 6
  special = false
}

# BUG: "count" is a reserved meta-argument name and cannot be used as a resource label
resource "random_string" "count" {
  length  = 6
  special = false
}
