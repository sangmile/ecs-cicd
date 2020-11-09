data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.63.0"

  name             = "${local.prefix}-vpc"
  cidr             = "182.31.0.0/16"
  azs              = data.aws_availability_zones.available.names
  private_subnets  = ["182.31.1.0/24", "182.31.2.0/24", "182.31.3.0/24"]
  public_subnets   = ["182.31.4.0/24", "182.31.5.0/24", "182.31.6.0/24"]
  database_subnets = ["182.31.7.0/24", "182.31.8.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  single_nat_gateway = true
  enable_nat_gateway = true

}
