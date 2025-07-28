output "eks_admin_user_name" {
    description = " EKS admin IAM user"
  value = aws_iam_user.eks_admin.name

}
output "eks_admin_role_arn" {
  description = "EKS admin IAM role ARN"
  value = aws_iam_role.eks_admin_role.arn
}

output "eks_admin_instance_profile_name" {
  description = "EKS admin IAM instance profile name"
  value = aws_iam_instance_profile.eks_admin.name
}

output "eks_admin_access_key" {
  description = "EKS admin IAM access key"
  value = {
    access_key_id     = aws_iam_access_key.eks_admin.id
    secret_access_key = aws_iam_access_key.eks_admin.secret
  }
    sensitive = true
}

output "cluster_autoscaler_iam_role_arn" {
  description = "IAM role ARN for cluster autoscaler"
  value       = module.cluster_autoscaler_irsa_role.iam_role_arn
  
}