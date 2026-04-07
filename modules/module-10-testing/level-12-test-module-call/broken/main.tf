# Wrong module source path
module "greeter" {
  source = "../wrong/path"
  name   = "TerraformMissions"
}

output "greeting" {
  value = module.greeter.greeting
}
