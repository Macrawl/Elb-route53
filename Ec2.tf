
#To generate the pem file
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


#Create the public key that will be used to access AWS
resource "aws_key_pair" "key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

#private key that will be saved in the local machine in order to authenticate the public key before ssh into aws

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = "${var.ssh_key_name}.pem"
}

# create a data source for the latest Ubuntu LTS AMI
data "aws_ami" "ubuntu-LTS-free-tier" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# create 3 instances 
resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu-LTS-free-tier.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> ./host-inventory.ini"
  }

  
  tags = {
    Name = "ec2_instance_${count.index + 1}"
  }
}





