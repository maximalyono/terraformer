provider "aws" {
	region = "ap-southeast-1"
}

resource "aws_instance" "instance-ku" {
	ami = "ami-061eb2b23f9f8839c"
	instance_type = "t2.micro"

	tags = {
		Name = "yuhu-yuhu"
	}
}


