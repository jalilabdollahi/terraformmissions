module "generator" {
  source = "./modules/generator"
}

module "processor" {
  source   = "./modules/processor"
  input_id = module.generator.token_id
}

module "reporter" {
  source    = "./modules/reporter"
  processed = module.processor.processed_value
}

output "final_report" {
  value = module.reporter.report
}
