resource "aws_iam_user" "eks_admin" {
  name = "${var.clustername}_admin"
  path = "/"

  tags = var.tags
}
resource "aws_iam_access_key" "eks_admin" {
  user = aws_iam_user.eks_admin.name

}
resource "aws_iam_policy" "eks_admin" {
  name = "${var.clustername}_admin_policy"
  description = "Policy for EKS admin access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*",
          "iam:ListRoles",
          "iam:PassRole",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeSecurityGroups",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "eks_admin" {
  user       = aws_iam_user.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_role" "eks_admin_role" {
  name = "${var.clustername}_eks_admin_role"
  assume_role_policy = jsonencode({
     Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.eks_admin.arn
        }
      }
    ]
  })
    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_admin_role" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_instance_profile" "eks_admin" {
  name = "${var.clustername}_eks_admin_profile"
  role = aws_iam_role.eks_admin_role.name

  tags = var.tags
}

data "aws_caller_identity" "current" {

}

module "cluster_autoscaler_irsa_role" {
source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
version = "5.59.0"
role_name = "${var.clustername}-cluster-autoscaler"
attach_cluster_autoscaler_policy = true
cluster_autoscaler_cluster_names = [var.clustername]

oidc_providers = var.oidc_providers

tags = var.tags 
}
