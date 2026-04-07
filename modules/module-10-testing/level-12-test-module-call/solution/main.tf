module "greeter" {
  source = "./modules/greeter"
  name   = "TerraformMissions"
}

output "greeting" {
  value = module.greeter.greeting
}
