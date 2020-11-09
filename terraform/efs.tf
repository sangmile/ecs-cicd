module "efs" {
    source = "./modules/efs"

    name = "${local.prefix}-efs"
    private_subnets = module.vpc.private_subnets
    ecs_security_group_id = module.ecs_security_group.this_security_group_id
}