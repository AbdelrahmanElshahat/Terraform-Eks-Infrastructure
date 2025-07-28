variable "clustername" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}
variable "private_subnets_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "endpoint_public_access_cidrs" {
  description = "CIDRs for public access to the EKS cluster endpoint"
  type        = list(string)
}
variable "eks_admin_role_arn" {
  description = "ARN of the IAM role for EKS admin access"
  type        = string
}
variable "cluster_autoscaler_role_arn" {
  description = "ARN of the IAM role for cluster autoscaler"
  type        = string
  
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
  
}
variable "tags" {
  description = "Tags to apply to the EKS cluster and resources"
  type        = map(string)
  default     = {}
}
variable "oidc_providers" {
  description = "OIDC providers for IRSA"
  type        = map(object({
    provider_arn               = string
    namespace_service_accounts = list(string)
  }))
  default     = {}
}