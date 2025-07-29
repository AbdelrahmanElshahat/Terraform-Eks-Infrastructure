output "vpc_id" {
  value = module.myapp-vpc.vpc_id
}
output "private_subnet_ids" {
  value = module.myapp-vpc.private_subnets
}
output "public_subnet_ids" {
  value = module.myapp-vpc.public_subnets
}