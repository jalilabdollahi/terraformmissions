variable "services" {
  type = map(object({
    port = number
    env  = string
  }))
  default = {
    svc_01 = { port = 8001, env = "prod" }
    svc_02 = { port = 8002, env = "prod" }
    svc_03 = { port = 8003, env = "staging" }
    svc_04 = { port = 8004, env = "prod" }
    svc_05 = { port = 8005, env = "dev" }
    svc_06 = { port = 8006, env = "prod" }
    svc_07 = { port = 8007, env = "staging" }
    svc_08 = { port = 8008, env = "prod" }
    svc_09 = { port = 8009, env = "dev" }
    svc_10 = { port = 8010, env = "prod" }
  }
}
