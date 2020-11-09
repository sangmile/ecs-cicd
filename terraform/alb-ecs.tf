module "alb_ecs" {
  source = "terraform-aws-modules/alb/aws"

  name = "${local.prefix}-ecs-alb"

  vpc_id          = module.vpc.vpc_id
  security_groups = [module.ecs_alb_security_group.this_security_group_id]
  subnets         = module.vpc.public_subnets

  target_groups = [
    {
      name_prefix      = "80"
      backend_protocol = "HTTP"
      backend_port     = "80"
      target_type      = "instance"
      health_check = {
        path = "/health"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

}
