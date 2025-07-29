data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}
resource "aws_security_group" "bastion" {
  name_prefix = "${var.cluster_name}-bastion-"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-bastion-sg"
  })
}

locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    cluster_name          = var.eks_cluster_name
    cluster_endpoint      = var.eks_cluster_endpoint
    aws_region           = data.aws_region.current.name
    access_key_id        = var.eks_admin_user_credentials.access_key_id
    secret_access_key    = var.eks_admin_user_credentials.secret_access_key
    cluster_autoscaler_yaml_content = var.cluster_autoscaler_yaml_content
  })
}
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.bastion_instance_type
  key_name      = var.key_pair_name

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  iam_instance_profile = var.eks_admin_instance_profile_name

  user_data_base64 = base64encode(local.user_data)
  associate_public_ip_address = true
  tags = merge(var.tags, {
    Name = "${var.cluster_name}-bastion"
    type = "bastion"
  })
}
data "aws_region" "current" {
}
