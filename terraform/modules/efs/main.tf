resource "aws_efs_file_system" "this" {
  creation_token = var.name

  tags = {
    Name = var.name
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.private_subnets[count.index]
  security_groups = [
    var.ecs_security_group_id
  ]
}
