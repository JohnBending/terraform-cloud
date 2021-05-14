
# Создание и привязывание IP адресса
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_ubuntu.id
  tags = {
    Name  = "Web Server IP"
    Owner = "Ivan Andreev"
  }
}

resource "aws_instance" "my_ubuntu" {
  ami                    = "ami-00399ec92321828f5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = "aws-key" //можно добавить имя ключа что бы был досуп по ssh
  user_data              = file("script.sh")

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Ivan Andreev"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "Dynamic security group"
  description = "My WebServer security group"


  dynamic "ingress" {
    for_each = ["22", "80", "443", "8080", "51820"]
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_webserver"
  }
}
