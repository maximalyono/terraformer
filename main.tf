provider "aws" {
	region = "ap-southeast-1"
}

resource "aws_launch_configuration" "example" {
	image_id = "ami-061eb2b23f9f8839c"
	instance_type = "t2.micro"
	security_groups = [aws_security_group.sec-group.id]

	user_data = <<-EOF
					#!/bin/bash
						echo "Hello bung" > index.html
						nohup busybox httpd -f -p ${var.server_port} & 
						EOF

	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_autoscaling_group" "sample" {
	launch_configuration = aws_launch_configuration.example.name
	vpc_zone_identifier = data.aws_subnet_ids.default.ids

	min_size = 2
	max_size = 10

	tag {
		key = "Name"
		value = "asg-terraform"
		propagate_at_launch = true
	}
}

resource "aws_security_group" "sec-group" {
	name = "terraformer"

	ingress {
		from_port = var.server_port
		to_port = var.server_port
		cidr_blocks = ["0.0.0.0/0"]
		protocol = "tcp"
	}
}

variable "server_port" {
	default = 8080
}

data "aws_vpc" "default" {
	default = true
}

data "aws_subnet_ids" "default" {
	vpc_id = data.aws_vpc.default.id
}
