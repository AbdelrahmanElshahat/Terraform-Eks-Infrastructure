#!/bin/bash
# modules/bastion/user-data.sh
# Update system
yum update -y

# Install required packages
yum install -y curl unzip git jq
yum install -y htop tree nano vim
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Install kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-05-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin

# Install aws-iam-authenticator
curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.14/aws-iam-authenticator_0.6.14_linux_amd64
chmod +x ./aws-iam-authenticator
mv ./aws-iam-authenticator /usr/local/bin

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create eks-manager user
useradd -m -s /bin/bash eks-manager
usermod -aG wheel eks-manager

# Setup AWS credentials for eks-manager user
mkdir -p /home/eks-manager/.aws
cat > /home/eks-manager/.aws/credentials << EOF
[default]
aws_access_key_id = ${access_key_id}
aws_secret_access_key = ${secret_access_key}
EOF

cat > /home/eks-manager/.aws/config << EOF
[default]
region = ${aws_region}
output = json
EOF

# Set proper permissions
chown -R eks-manager:eks-manager /home/eks-manager/.aws
chmod 600 /home/eks-manager/.aws/credentials
chmod 600 /home/eks-manager/.aws/config

# Configure kubectl for eks-manager user
sudo -u eks-manager aws eks update-kubeconfig --region ${aws_region} --name ${cluster_name}


# Create cluster-autoscaler deployment file (will be populated by Terraform)
cat > /home/eks-manager/cluster-autoscaler.yaml << 'EOF'
${cluster_autoscaler_yaml_content}
EOF
chown eks-manager:eks-manager /home/eks-manager/cluster-autoscaler.yaml