variable "queues" {
  type = map(object({
    skill        = string
    bitrate_kbps = optional(number, 128)
    jingle       = optional(bool, true)
  }))
}

output "rota" {
  value = [
    for name, s in var.queues :
    "${name} ${s.skill}@${s.bitrate_kbps}k${s.jingle ? " +jingle" : ""}"
  ]
}
