output "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  value       = module.myapp-vpc.vpc_id
  
}
output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.clustername
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
  
}
output "bastion_host_public_ip" {
  description = "Public IP of the Bastion host"
  value       = aws_instance.bastion.public_ip
}
output "bastion_host_ssh_command" {
  description = "SSH command to connect to the Bastion host"
  value       = module.bastion_host.ssh_command  
}
output "eks_admin_user_name" {
  description = "EKS admin IAM user name"
  value       = module.iam_roles.eks_admin_user_name
}
output "kubeconfig_command" {
  description = "Command to configure kubectl on bastion"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.clustername}"
}
