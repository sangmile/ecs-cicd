variable "name" {
    type = string
}

variable "private_subnets" {
    type = list(string)
    default = []
}

variable "ecs_security_group_id" {
    type = string
}