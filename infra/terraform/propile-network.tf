resource "aws_security_group" "allow_propile_server_incoming_traffic" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2018-02-07T16:49:43.748+01:00"
  vpc_id      = "vpc-0ebd292c9c9b3e710"
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
