###################### Pluralsight Instance ###########################
resource "aws_instance" "hacker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.lab-sg.id]
  private_ip             = "10.0.0.100"
  key_name               = "lab-key"

  user_data = <<EOF
#! /bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install jq -y
sudo mkdir /home/ubuntu/logs
EOF

####   Provisioner for Directory full of Lab files #######

  provisioner "file" {
    source      = "logs"
    destination = "/home/ubuntu/logs"

    connection {
      type        = "ssh"
      host        = aws_instance.hacker.public_ip
      user        = "ubuntu"
      private_key = tls_private_key.rsa.private_key_pem
    }
  }

  tags = {
    Name = "Hackthebox"
  }

}



####   SSH Keys and PEM File ########

resource "aws_key_pair" "deployer" {
  key_name   = "lab-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "test-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "test-key"

}

