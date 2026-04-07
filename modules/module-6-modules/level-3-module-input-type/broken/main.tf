# port must be a number but a string is being passed.
module "server" {
  source = "./modules/server"
  port   = "8080"
}
