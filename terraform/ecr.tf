module "ecr" {
  source = "./modules/ecr"
  name   = "${local.prefix}-repo"

  scan_on_push = true
}
