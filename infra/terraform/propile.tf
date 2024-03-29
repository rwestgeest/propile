resource "aws_key_pair" "propile-machine" {
  key_name = "propile-machine"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/dCIndvf278jXPEcnlHbHPtJR3OE16yPbsz1/QzcpFVnGAeAFdwYRFDosduoOcvC4IlBqO+Lb5gxmJLOMUB2RBd9NM07a694OXCE5++PSeCCuFpiO+QbGCsSxt7svi/Ck7Qe4k211YyQZRrtbAFhTXx6xH3f2Kiy/yvyt1tsM3rzzQJNXd3ZVEVofamkA8jh+c0niRrr9rGuXUQ3XbWLlucfLppUe0MDMVjlgr7q1olqB44e4bDOv1QZQMMk2iOOU/a5e3bowuRhxlRjWS267fVW+8PSwD2tRZhKDTiXUpRJF8loaoZhPIPXB+IVq/N8/2OaKrmZpD1AwiyiBzrUeNNIoZQNAz9CNShj6EmhWqDjaSJdMzaM9X82pXFdR/ExiIGzimcvBKAqlEOGkefFJ0cB7YMvZ6dzMH+xrKjXfacuj6k7eKz3gVviD4lPU6dGpmCZP80Pxbph5gP4cqAJK1jIxvoe6Cb9A/jYJ2PVJCE4J9oO+//4+ZZu2QEgHKE0= dimitribauwens@MacBook-Pro-van-Dimitri.local"
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
  subnet_id = "subnet-014d79c7d63c86192"
  tenancy = "default"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa_propile_pem")
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

