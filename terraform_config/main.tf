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

# Creacion de la llave pem para la instancia
resource "tls_private_key" "keyRSA" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#Crea el archivo con la llave
resource "local_file" "private_key" {
  filename = "${path.module}/keyRSA_aws.pem"
  content  = tls_private_key.keyRSA.private_key_pem
}

# Crea el par de llaves
resource "aws_key_pair" "keyRSA_pair" {
  key_name   = "keyRSA_aws"
  public_key = tls_private_key.keyRSA.public_key_openssh
}


# Para crear nombres aleatorios
resource "random_pet" "name" {}

# Instancia EC2 master
resource "aws_instance" "master" {
    ami           = "ami-0277155c3f0ab2930"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    key_name = aws_key_pair.keyRSA_pair.key_name
    tags = {
        Name = "master-${random_pet.name.id}"
    }

    provisioner "file" {
        source      = "../dist"
        destination = "dist"

        connection {
        type        = "ssh"
        user        = "ec2-user" # Usuario de la instancia EC2 (puede variar según la AMI)
        private_key = tls_private_key.keyRSA.private_key_pem  # Utiliza la clave PEM generada por tls_private_key
        host        = self.public_ip
        }
    }

    provisioner "file" {
        source      = "../ansible_config"
        destination = "ansible_config"

        connection {
        type        = "ssh"
        user        = "ec2-user" # Usuario de la instancia EC2 (puede variar según la AMI)
        private_key = tls_private_key.keyRSA.private_key_pem  # Utiliza la clave PEM generada por tls_private_key
        host        = self.public_ip
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update",
            "sudo yum install ansible -y",
            "echo '${tls_private_key.keyRSA.private_key_pem}' > keyRSA_aws.pem",  # Copiar la clave SSH a la instancia
            "chmod 400 keyRSA_aws.pem && chmod 600 keyRSA_aws.pem",  # Ajustar los permisos de la clave
            "echo \"[clients]\n${aws_instance.client.public_dns}\n[clients:vars]\nansible_ssh_common_args='-o StrictHostKeyChecking=no' \" > inventory.ini",
            "mv ansible_config/* ./",
            "rm -rf ansible_config/",
            "ansible-playbook -i inventory.ini client-ansible.yml --private-key ./keyRSA_aws.pem",

        ]

        connection {
        type        = "ssh"
        user        = "ec2-user" # Usuario de la instancia EC2 (puede variar según la AMI)
        private_key = tls_private_key.keyRSA.private_key_pem  # Utiliza la clave PEM generada por tls_private_key
        host        = self.public_ip
        }
    }
}
# Instancia EC2 cliente
resource "aws_instance" "client" {
    ami           = "ami-0277155c3f0ab2930"
    instance_type = "t2.micro"
    #user_data     = file("init-script.sh")
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    key_name = aws_key_pair.keyRSA_pair.key_name
    tags = {
        Name = "client-${random_pet.name.id}"
    }
}

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "web-sg" {
    name = "${random_pet.name.id}-sg"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}