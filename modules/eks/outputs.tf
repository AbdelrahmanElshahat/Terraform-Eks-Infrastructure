output "eks_admin_access_key" {
  description = "EKS admin access key"
  value = {
    access_key_id     = aws_iam_access_key.eks_admin.id
    secret_access_key = aws_iam_access_key.eks_admin.secret
  }
  sensitive = true
}


output "clustername" {
  description = "Name of the EKS cluster"
  value = var.clustername
}
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for the EKS cluster"
  value       = module.eks.oidc_provider_arn
}
output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate authority data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}
/*output "cluster_autoscaler_role_arn" {
  description = "Cluster autoscaler IAM role ARN"
  value       = module.cluster_autoscaler_irsa_role.iam_role_arn
}*/
output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}
output "eks_admin_user_name" {
  description = "EKS admin IAM user name"
  value       = aws_iam_user.eks_admin.name
}

output "eks_admin_role_arn" {
  description = "EKS admin IAM role ARN"
  value       = aws_iam_role.eks_admin_role.arn
}

output "eks_admin_instance_profile_name" {
  description = "EKS admin instance profile name"
  value       = aws_iam_instance_profile.eks_admin.name
}
output "cluster_autoscaler_yaml_content" {
  value = templatefile("${path.module}/cluster-autoscaler.yaml.tpl", {
    cluster_name                = var.clustername
    cluster_autoscaler_role_arn = module.cluster_autoscaler_irsa_role.iam_role_arn
    aws_region                  = data.aws_region.current.name
  })
}