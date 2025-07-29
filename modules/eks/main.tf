module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.clustername
  kubernetes_version = var.kubernetes_version


  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets_ids

  endpoint_private_access      = true
  endpoint_public_access       = true
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs

  enable_irsa = true

access_entries = {
  # Keep the existing role entry with the same name
  eks_admin = {
    principal_arn = aws_iam_role.eks_admin_role.arn
    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
  
  # Add the IAM user entry
  eks_admin_user = {
    principal_arn = aws_iam_user.eks_admin.arn
    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}
  
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {
    }
    vpc-cni = {
      before_compute = true
    }
  }
  eks_managed_node_groups = {
    main = {
      name = "main-ng"

      instance_types = var.node_group_config.instance_types
      ami_type       = var.node_group_config.ami_type

      min_size     = var.node_group_config.min_size
      max_size     = var.node_group_config.max_size
      desired_size = var.node_group_config.desired_size

      # Enable cluster autoscaler tags
      tags = merge(var.tags, {
        "k8s.io/cluster-autoscaler/enabled"            = "true"
        "k8s.io/cluster-autoscaler/${var.clustername}" = "owned"
      })
    }
  }

  tags = var.tags
}

resource "local_file" "cluster_autoscaler_yaml" {
  content = templatefile("${path.module}/cluster-autoscaler.yaml.tpl", {
    cluster_name                = var.clustername
    cluster_autoscaler_role_arn = module.cluster_autoscaler_irsa_role.iam_role_arn
    aws_region                  = data.aws_region.current.name
  })
  filename = "${path.module}/cluster-autoscaler.yaml"
}
module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                        = "${var.clustername}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.clustername]

 oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  tags = var.tags
}
data "aws_region" "current" {}





