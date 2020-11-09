module "efs_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-efs-sg"
  description = "${local.prefix}-efs-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = 6
      source_security_group_id = module.ecs_security_group.this_security_group_id
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}