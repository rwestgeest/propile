resource "aws_key_pair" "propile-machine" {
  key_name = "propile-machine"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7z+3Gu1yPnj1XPnkXY4droW8q1U+jYsQD5kpxHn/WRyfTWpwLqmePQoD5v7ChPr6eX0+3E9nEexlZJ73KcfdjYUVch4eQqcXbWUcGUxRXrvhHwDti48v+2WB6t9XaaMLyilQbwmNGPd8ydOxSskmNjxjkWglprXKDdzWInyo3Qrmaco9gCuBDNV2QSv9X5ozC31lw2J1J/trgmIuvmZ3/79L7hbY/tGvkKmfNjZL0kUI+5HcY2Snl6Tk6AdhRubYVhA3CUu5A+5C8qUYg6P40XcVpiDLfLrlug3Z07DGgZ6DDIwTUpGduZ6+7cYHDMMNMyK++gcSLwLms8+vCKf/v rob@bargeld"
}

resource "aws_instance" "propile-production-server" {
  ami = "ami-0767046d1677be5a0" # ubuntu 20.04
  associate_public_ip_address = true
  availability_zone = "eu-central-1b"
  disable_api_termination = false
  ebs_optimized = false
  instance_type = "t3a.micro"
  key_name = "propile-machine"
  monitoring = false
  root_block_device {
    delete_on_termination = true
    volume_size = "50"
    volume_type = "gp2"
    encrypted = true
  }
  vpc_security_group_ids = [aws_security_group.allow_propile_server_incoming_traffic.id]
  source_dest_check = true
  subnet_id = "subnet-b478a7c9"
  tenancy = "default"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa_propile")
  }

  provisioner "remote-exec" {
    scripts = [
      "install-docker.sh"
    ]
  }
  tags = {
    Name = "propile-prd"
    Infra = "propile"
  }
}

resource "aws_security_group" "allow_propile_server_incoming_traffic" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2018-02-07T16:49:43.748+01:00"
  vpc_id      = "vpc-818250ea"
  tags = {
    "Name" = "allow_rails_ports_aws_linux"
  }
}

resource "aws_security_group_rule" "allow_port_80_for_propile_server" {
  type = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_propile_server_incoming_traffic.id
}

resource "aws_security_group_rule" "allow_port_443_for_propile_server" {
  type = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_propile_server_incoming_traffic.id
}


resource "aws_security_group_rule" "allow_port_22" {
  type = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_propile_server_incoming_traffic.id
}

resource "aws_security_group_rule" "allow_all_out" {
  type  = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_propile_server_incoming_traffic.id
}
