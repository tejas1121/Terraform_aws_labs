data "aws_ami" "ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "nginx_server" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  associate_public_ip_address = true
  user_data    = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install nginx1.12 -y
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "Hello from Terraform" > /usr/share/nginx/html/index.html
                EOF
  tags = {
    Name = "NGINX-SERVER"
  }
}