variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where bastion will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs (for reference)"
  type        = list(string)
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for bastion host"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access bastion host"
  type        = list(string)
}
variable "eks_cluster_name" {
  description = "Name of the EKS cluster for which the bastion host is being set up"
  type        = string
  
}
variable "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "eks_admin_user_credentials" {
  description = "EKS manager user credentials"
  type = object({
    access_key_id     = string
    secret_access_key = string
  })
  sensitive = true
}

variable "tags" {
  description = "Tags to apply to the bastion host and resources"
  type        = map(string)
  default     = {}
}
variable "eks_admin_instance_profile_name" {
  description = "IAM instance profile name for EKS admin"
  type        = string
}
variable "cluster_autoscaler_yaml_content" {
  description = "Content of the cluster autoscaler YAML file"
  type        = string
}