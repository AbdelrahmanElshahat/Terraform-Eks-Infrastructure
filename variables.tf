variable "aws_region" {
  description = "AWS region for the bastion host and EKS cluster"
  type        = string
  default     = "eu-north-1"
}

variable "clustername" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "micro-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24","10.0.6.0/24"]
}

variable "endpoint_public_access_cidrs" {
  description = "CIDRs for public access to the EKS cluster endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_group_config" {
  description = "Configuration for the EKS managed node group"
  type = object({
    instance_types = list(string)
    ami_type       = string
    min_size       = number
    max_size       = number
    desired_size   = number
  })
  default = {
    instance_types = ["t3.medium"]
    ami_type       = "AL2_x86_64"
    min_size       = 1
    max_size       = 5
    desired_size   = 2
  }
}

variable "bastion_allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for accessing the bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}
variable "key_pair_name" {
  description = "Name of the AWS key pair for bastion host"
  type        = string
}

variable "bastion_allowed_cidrs" {
  description = "CIDR blocks allowed to access bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "EKS-Cluster"
    ManagedBy   = "Terraform"
  }
}