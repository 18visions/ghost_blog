variable "ghost_pw" {
    description = "Password for the ghost admin user"
    type        = string
}

variable "environment" {
    description = "Environment for the ghost blog"
    type        = string
}

variable "vpc_id" {
    description = "VPC ID for the ghost blog"
    type        = string
}