output "public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip

}

output "private_ip" {
  description = "Private IP of the bastion host"
  value       = aws_instance.bastion.private_ip

}


output "instance_id" {
  description = "Instance ID of the bastion host"
  value       = aws_instance.bastion.id

}
output "security_group_id" {
  description = "Security group ID for the bastion host"
  value       = aws_security_group.bastion.id

}

output "ssh_command" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.bastion.public_ip}"

}
