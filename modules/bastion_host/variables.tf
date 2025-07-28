variable "clustername" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID for the bastion host"
  type        = string
  
}
variable "public_subnet_id" {
  description = "Public subnet ID for the bastion host"
  type        = string
}

variable "private_subnets_ids" {
  description = "Private subnet IDs for reference in security groups"
  type        = list(string)

}
variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
  
}
variable "key_pair_name" {
  description = "Name of the key pair for SSH access to the bastion host"
  type        = string
}
variable "allowed_cidr_blocks" {
    description = "CIDR blocks allowed to access the bastion host via SSH"
    type        = list(string) 
}
variable "eks_cluster_name" {
  description = "Name of the EKS cluster for which the bastion host is set up"
  type        = string
  
}
variable "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
  
}

variable "eks_admin_user_credentials" {
    description = "Credentials for the EKS admin user"
    type = object({
        access_key_id     = string
        secret_access_key = string
    })
    sensitive = true
}
variable "eks_admin_instance_profile_name" {
  description = "Name of the IAM instance profile for the EKS admin user"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bastion host and resources"
  type        = map(string)
  default     = {}
}