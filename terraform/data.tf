# data source to get the vpc id. should take variable for vpc id
data "vpc_id" "vpc" {
    vpcid = var.vpc_id
}