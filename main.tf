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


module "eks" {
  source = "./modules/eks"

  clustername        = var.clustername
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  private_subnets_ids          = module.vpc.private_subnet_ids
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs
  node_group_config            = var.node_group_config
  tags = var.common_tags
}

module "bastion_host" {
  source = "./modules/bastion_host"

  vpc_id                        = module.vpc.vpc_id
  public_subnet_id              = module.vpc.public_subnet_ids[0]
  private_subnet_ids            = module.vpc.private_subnet_ids
  cluster_name                  = module.eks.clustername
  eks_cluster_name              = module.eks.clustername
  bastion_instance_type         = var.bastion_instance_type
  key_pair_name                 = var.key_pair_name
  allowed_cidr_blocks           = var.bastion_allowed_cidr_blocks
  eks_cluster_endpoint          = module.eks.cluster_endpoint
  eks_admin_user_credentials    = module.eks.eks_admin_access_key
  eks_admin_instance_profile_name = module.eks.eks_admin_instance_profile_name
  cluster_autoscaler_yaml_content = module.eks.cluster_autoscaler_yaml_content
  tags                          = var.common_tags
  depends_on = [module.eks]

}
resource "aws_security_group_rule" "bastion_to_eks" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_security_group_id
  security_group_id        = module.bastion_host.bastion_security_group_id
  description              = "Allow bastion to communicate with EKS cluster"
}

# Security group rule to allow EKS cluster to receive from bastion
resource "aws_security_group_rule" "eks_from_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.bastion_host.bastion_security_group_id
  security_group_id        = module.eks.cluster_security_group_id
  description              = "Allow bastion host access to EKS cluster"
}