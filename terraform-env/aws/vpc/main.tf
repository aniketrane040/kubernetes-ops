locals {
  aws_region       = "us-east-1"
  environment_name = "dev"
  cluster_name     = "arane-dev"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-env/aws/vpc",
    ops_owners           = "arane",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "s3" {
    bucket = "terraform-k8s-infra-state"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = local.aws_region
}

#
# VPC
#
module "vpc" {
  source = "../../../terraform-modules/aws/vpc"

  aws_region       = local.aws_region
  azs              = ["us-east-1a", "us-east-1c", "us-east-1d"]
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment_name = local.environment_name
  cluster_name     = local.cluster_name
  tags             = local.tags
}
