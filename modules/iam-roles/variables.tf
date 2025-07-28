variable "clustername" {
  description = "Name of the EKS cluster"
  type        = string
  
}
variable "tags" {
  description = "Tags to apply to all resources"
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