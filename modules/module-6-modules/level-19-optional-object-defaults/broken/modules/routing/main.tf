variable "queues" {
  type = map(object({
    skill        = string
    bitrate_kbps = number
    jingle       = bool
  }))
}

output "rota" {
  value = [
    for name, s in var.queues :
    "${name} ${s.skill}@${s.bitrate_kbps}k${s.jingle ? " +jingle" : ""}"
  ]
}
