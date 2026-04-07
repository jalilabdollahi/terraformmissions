# These resources have been migrated from count to for_each.
# The moved blocks below are incorrect — they use unquoted identifiers as the 'to' keys
# instead of quoted string keys.

resource "local_file" "service" {
  for_each = toset(["web", "api", "worker"])
  content  = "service: ${each.key}"
  filename = "${path.module}/service-${each.key}.txt"
}

# Bug: 'to' keys should be quoted strings like ["web"], ["api"], ["worker"]
moved {
  from = local_file.service[0]
  to   = local_file.service[web]
}

moved {
  from = local_file.service[1]
  to   = local_file.service[api]
}

moved {
  from = local_file.service[2]
  to   = local_file.service[worker]
}
