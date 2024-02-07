 # Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
/*terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 3.5.0"
      }
    }
    
}*/

provider "aws" {
  region = "us-east-1"
  
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_instance" "master" {
    ami           = "ami-0277155c3f0ab2930"
    instance_type = "t2.micro"
    #user_data     = file("init-script.sh")
    vpc_security_group_ids = [aws_security_group.web-sg.id]

    tags = {
        Name = "master-${random_pet.name.id}"
    }
}

resource "aws_instance" "client" {
    ami           = "ami-0277155c3f0ab2930"
    instance_type = "t2.micro"
    #user_data     = file("init-script.sh")
    vpc_security_group_ids = [aws_security_group.web-sg.id]

    tags = {
        Name = "client-${random_pet.name.id}"
    }
}

resource "aws_security_group" "web-sg" {
    name = "${random_pet.name.id}-sg"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}