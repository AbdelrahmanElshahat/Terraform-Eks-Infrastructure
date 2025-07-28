aws_region                 = "eu-north-1"
clustername                = "microservice-cluster"
vpc_cidr_block             = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

endpoint_public_access_cidrs = ["197.35.254.113/32"]
bastion_allowed_cidr_blocks  = ["197.35.254.113/32"]

key_pair_name         = "server-key-pair"

common_tags = {
    Environment = "development"
    Project     = "microservice-architecture"
    ManagedBy   = "Terraform"
    owner       = "elshahat20"
    }   