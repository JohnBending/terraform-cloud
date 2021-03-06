#Autosearch ami
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "my_ubuntu" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name               = "aws-key" //можно добавить имя ключа что бы был досуп по ss
  user_data              = file("script.sh")

  tags = {
    Name  = "srv-jenkins-001 Build by Terraform"
    Owner = "Ivan Andreev"
  }
}

#Create static IP adreses from instance
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_ubuntu.id
  tags     = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP" })

}

resource "aws_security_group" "my_webserver" {
  name        = "Jenkins security group"
  description = "Jenkins security group"


  dynamic "ingress" {
    for_each = var.allow_ports
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
    Name = "srv-jenkins-001"
  }
}
