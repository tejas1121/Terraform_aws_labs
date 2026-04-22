
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_instance" "my_ec2" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    count = 4
    subnet_id = count.index < 2 ? aws_subnet.main[0].id : aws_subnet.main[1].id
   
    tags = {
        Name = "my-ec2-instance-${count.index + 1}"
    }
}