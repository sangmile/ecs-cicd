## Allocate EIP
resource "aws_eip" "this" {
  vpc      = true
  instance = module.ec2_bastion.id[0]
}

## Create bastion server
module "ec2_bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = 1

  name                        = "${local.prefix}-bastion"
  ami                         = "ami-064a198accc7e80e0"
  instance_type               = "t3.micro"
  subnet_id                   = tolist(module.vpc.public_subnets)[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.bastion_security_group.this_security_group_id]
  key_name                    = "${local.prefix}-bastion-keypair"

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
    }
  ]

  tags = {
    "Name" = "${local.prefix}-bastion"
  }
}

## Bastion Security Group
module "bastion_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-bastion-sg"
  description = "${local.prefix}-bastion-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "58.124.137.165/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "61.34.245.204/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "58.72.62.252/32"
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
