output "ec2_public_ipv4" {
  value = aws_instance.ec2.public_ip
}