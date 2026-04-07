resource "local_file" "service" {
  for_each = toset(["web", "api", "worker"])
  content  = "service: ${each.key}"
  filename = "${path.module}/service-${each.key}.txt"
}

moved {
  from = local_file.service[0]
  to   = local_file.service["web"]
}

moved {
  from = local_file.service[1]
  to   = local_file.service["api"]
}

moved {
  from = local_file.service[2]
  to   = local_file.service["worker"]
}
