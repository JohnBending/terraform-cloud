data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.server_size
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("jenkins.sh")

  tags = {
    Name  = "${var.server_name}-WebServer"
    Owner = "Ivan Andreev"
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${var.server_name}-WebServer-SG"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "55555"]
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  tags = {
    Name  = "${var.server_name}-WebServer SecurityGroup"
    Owner = "Ivan Andreev"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = {
    Name  = "${var.server_name}-WebServer-IP"
    Owner = "Ivan Andreev"
  }
}
