locals {
  name        = "${local.prefix}-ecs"
  environment = "prod"

  # This is the convention we use to know what belongs to each other
  ec2_resources_name = local.name
}

#----- ECS --------
module "ecs" {
  source             = "terraform-aws-modules/ecs/aws"
  name               = local.name
  container_insights = true
}

module "ec2-profile" {
  source = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  name   = local.name
}

#----- ECS  Resources--------

#For now we only use the AWS ECS optimized ami <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>

module "this" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = local.ec2_resources_name

  # Launch configuration
  lc_name = local.ec2_resources_name

  image_id             = "ami-0cc0a1657e6978861"
  instance_type        = "m5.large"
  security_groups      = [module.ecs_security_group.this_security_group_id]
  iam_instance_profile = module.ec2-profile.this_iam_instance_profile_id
  user_data            = data.template_file.user_data.rendered
  key_name             = "${local.prefix}-ecs-keypair"
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 100
    },
  ]

  # Auto scaling group
  asg_name                  = local.ec2_resources_name
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = local.environment
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = local.name
      propagate_at_launch = true
    },
  ]
}

data "template_file" "user_data" {
  template = file("./templates/user-data.sh")
  vars = {
    cluster_name = local.name,
    efs_id       = module.efs.id
  }
}
