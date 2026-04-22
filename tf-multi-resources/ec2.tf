

resource "aws_instance" "my_ec2" {
    count = 2
    ami = count.index <1 ? "ami-0e12ffc2dd465f6e4" : "ami-05d2d839d4f73aafb"
    instance_type = var.instance_type
  
    subnet_id = count.index < 1 ? aws_subnet.main[0].id : aws_subnet.main[1].id
   
    tags = {
        Name = "my-ec2-instance-${count.index + 1}"
    }
}