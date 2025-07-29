output "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  value = module.vpc.vpc_id
}
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.clustername
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}
// Removed invalid eks_cluster_endpoint output. Use correct value if needed.
// Removed invalid bastion_host_public_ip output. No aws_instance.bastion resource declared.
output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = module.bastion_host.public_ip
}
output "bastion_ssh_command" {
  description = "SSH command to connect to bastion"
  value       = module.bastion_host.ssh_command
}
// Removed invalid eks_admin_user_name output. iam_roles module removed.
output "kubeconfig_command" {
  description = "Command to configure kubectl on bastion"
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.clustername}"
}
