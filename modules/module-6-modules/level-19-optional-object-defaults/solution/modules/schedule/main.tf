variable "streams" {
  type = map(object({
    genre        = string
    bitrate_kbps = optional(number, 128)
    jingle       = optional(bool, true)
  }))
}

output "lineup" {
  value = [
    for name, s in var.streams :
    "${name} ${s.genre}@${s.bitrate_kbps}k${s.jingle ? " +jingle" : ""}"
  ]
}
