provider "aws" {
	region = "ap-southeast-1"
}

resource "aws_instance" "instance-ku" {
	ami = "ami-061eb2b23f9f8839c"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.sgroup.id}"]

	user_data = <<-EOF
					#!/bin/bash	
						echo "Hello, world" > index.html
						nohup busybox httpd -f -p 8080 &
						EOF

	tags = {
		Name = "yiuhu-yiuhu"
	}
}

resource "aws_security_group" "sgroup" {

	name = "terraform-instance-ku"

 	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
