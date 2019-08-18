terraform {
  required_version = ">= 0.12.1"
  backend "s3" {}
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  status = "available"
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.4.2"
  namespace  = var.namespace
  stage      = var.stage
  cidr_block = var.cidr_block
  name       = var.name
  tags       = var.tags
  attributes = var.attributes
}

module "dynamic_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.0"
  namespace          = var.namespace
  stage              = var.stage
  region             = data.aws_region.current.name
  availability_zones = data.aws_availability_zones.available.names
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  cidr_block         = var.cidr_block
  name               = var.name
  tags               = var.tags
  attributes         = var.attributes
}