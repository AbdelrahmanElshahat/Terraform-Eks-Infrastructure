#!/bin/bash

# Update the system
sudo yum update -y
# Install necessary packages
yum install -y curl unzip git jq
yum install -y htop tree nano vim
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

#install kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-05-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin

#install aws-iam-authenticator
curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.14/aws-iam-authenticator_0.6.14_linux_amd64
chmod +x ./aws-iam-authenticator
mv ./aws-iam-authenticator /usr/local/bin

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# create eks-admin user
useradd -m -s /bin/bash eks-admin
usermod -aG wheel eks-admin

# setup aws credentials for eks-admin user
mkdir -p /home/eks-admin/.aws
cat > /home/eks-admin/.aws/credentials <<EOF
[default]
aws_access_key_id = ${access_key_id}
aws_secret_access_key = ${secret_access_key}
EOF
cat > /home/eks-admin/.aws/config <<EOF
[default]
region = ${aws_region}
output = json
EOF

# set permissions for the .aws directory
chown -R eks-admin:eks-admin /home/eks-admin/.aws
chmod 600 /home/eks-admin/.aws/credentials
chmod 600 /home/eks-admin/.aws/config

# configure kubectl for eks-admin user
sudo -U eks-admin aws eks update-kubeconfig --name ${cluster_name} --region ${aws_region}

touch /home/eks-admin/cluster-autoscaler.yaml
chown eks-admin:eks-admin /home/eks-admin/cluster-autoscaler.yaml

