variable "streams" {
  type = map(object({
    genre        = string
    bitrate_kbps = number
    jingle       = bool
  }))
}

output "lineup" {
  value = [
    for name, s in var.streams :
    "${name} ${s.genre}@${s.bitrate_kbps}k${s.jingle ? " +jingle" : ""}"
  ]
}
