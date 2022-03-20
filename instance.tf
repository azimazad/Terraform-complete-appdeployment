terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }

}
resource "aws_key_pair" "demokey" {
  key_name   = "demokey"
  public_key = file("demokey.pub")
}


#VPC resources

resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "demo-pub-1" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE
  tags = {
    Name = "demo-pub-1"
  }
}

resource "aws_subnet" "demo-priv-1" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE
  tags = {
    Name = "demo-priv-1"
  }
}

resource "aws_internet_gateway" "demo-IGW" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-IGW"
  }
}


resource "aws_route_table" "demo-pub-RT" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-IGW.id
  }

  tags = {
    Name = "demo-pub-RT"
  }
}

resource "aws_route_table_association" "demo-pub-1-a" {
  subnet_id      = aws_subnet.demo-pub-1.id
  route_table_id = aws_route_table.demo-pub-RT.id
}

#EC2 Resource


resource "aws_instance" "demo-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE
  subnet_id              = aws_subnet.demo-pub-1.id
  key_name               = aws_key_pair.demokey.key_name
  vpc_security_group_ids = [aws_security_group.demo_stack_sg.id]
  tags = {
    Name    = "demo-instance"
    Project = "demoapp"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]

  }

  connection {
    user        = var.USER
    private_key = file("demokey")
    host        = self.public_ip
  }
}

resource "aws_security_group" "demo_stack_sg" {
  vpc_id      = aws_vpc.demo.id
  name        = "demo-stack-sg"
  description = "Sec Grp for demo ssh"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}


output "PublicIP" {
  value = aws_instance.demo-inst.public_ip
}

output "PrivateIP" {
  value = aws_instance.demo-inst.private_ip
}