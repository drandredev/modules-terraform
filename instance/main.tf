provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "ssh_connection" {
  name        = var.sg_name
  description = "Allow SSH Connections"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "allow_ssh"
  }
}
resource "aws_instance" "platzi-instance" {
  # ami           = "ami-078fa525e8cd966df"
  ami             = var.ami_id
  key_name        = "personalkeyandre"
  instance_type   = var.instance_type
  tags            = var.tags
  security_groups = [aws_security_group.ssh_connection.name]
}
