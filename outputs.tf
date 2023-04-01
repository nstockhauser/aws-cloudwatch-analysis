

### Public IP of Good Guy Computer ###

output "aws_instance_hacker_public_dns" {
  value = "ssh ubuntu@${aws_instance.hacker.public_ip} -i test-key"
}
