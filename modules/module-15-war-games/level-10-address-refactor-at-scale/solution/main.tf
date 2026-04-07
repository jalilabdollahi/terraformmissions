resource "random_string" "service_alpha" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_beta" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_gamma" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_delta" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_epsilon" {
  length  = 8
  special = false
  upper   = false
}

moved {
  from = random_string.svc_one
  to   = random_string.service_alpha
}

moved {
  from = random_string.svc_two
  to   = random_string.service_beta
}

moved {
  from = random_string.svc_three
  to   = random_string.service_gamma
}

moved {
  from = random_string.svc_four
  to   = random_string.service_delta
}

moved {
  from = random_string.svc_five
  to   = random_string.service_epsilon
}

output "service_ids" {
  value = [
    random_string.service_alpha.result,
    random_string.service_beta.result,
    random_string.service_gamma.result,
    random_string.service_delta.result,
    random_string.service_epsilon.result,
  ]
}
