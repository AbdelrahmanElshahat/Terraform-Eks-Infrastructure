terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                     = "./modules/vpc"
  vpc_cidr_block             = var.vpc_cidr_block
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  clustername                = var.clustername
}

module "iam-roles" {
  source      = "./modules/iam-roles"
  clustername = var.clustername

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
  tags       = var.common_tags
  depends_on = [module.eks]

}
module "eks" {
  source = "./modules/eks"

  clustername                  = var.clustername
  kubernetes_version           = var.kubernetes_version

  vpc_id                       = module.vpc.vpc_id
  private_subnets_ids          = module.vpc.private_subnet_ids
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs

  eks_admin_role_arn          = module.iam-roles.eks_admin_role_arn
  cluster_autoscaler_role_arn = module.iam-roles.cluster_autoscaler_role_arn

  node_group_config           = var.node_group_config

  tags                        = var.common_tags

}

module "bastion_host" {
  source = "./modules/bastion_host"

  clustername         = var.clustername
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  private_subnets_ids = module.vpc.private_subnet_ids

  bastion_instance_type           = var.bastion_instance_type
  key_pair_name                   = var.key_pair_name
  allowed_cidr_blocks             = var.bastion_allowed_cidr_blocks

  eks_cluster_name                = module.eks.clustername
  eks_cluster_endpoint            = module.eks.cluster_endpoint
  eks_admin_user_credentials      = module.eks.eks_admin_user_credentials
  eks_admin_instance_profile_name = module.iam-roles.eks_admin_instance_profile_name

  tags                            = var.common_tags
  
  depends_on                      = [module.iam-roles, module.eks]

}
