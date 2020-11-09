module "ecs_alb_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-ecs-alb-sg"
  description = "${local.prefix}-ecs-alb-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}