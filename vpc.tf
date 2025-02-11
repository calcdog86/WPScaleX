resource "aws_vpc" "webVPC" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support = true #gives you an internal domain name
    enable_dns_hostnames = true #gives you an internal host name
    instance_tenancy = "default"    
    tags = {
        Name = "webVPC"
    }
}

resource "aws_subnet" "webSub1" {
    vpc_id = "${aws_vpc.webVPC.id}"
    cidr_block = var.subnet_1_cidr
    map_public_ip_on_launch = true //it makes this a public subnet
    availability_zone = var.subnet_1_az
    tags = {
        Name = "webSub1"
    }
}

resource "aws_subnet" "webSub2" {
    vpc_id = "${aws_vpc.webVPC.id}"
    cidr_block = var.subnet_2_cidr
    map_public_ip_on_launch = true //it makes this a public subnet
    availability_zone = var.subnet_2_az
    tags = {
        Name = "webSub2"
    }
}

resource "aws_subnet" "webSub3" {
    vpc_id = "${aws_vpc.webVPC.id}"
    cidr_block = var.subnet_3_cidr
    map_public_ip_on_launch = true //it makes this a public subnet
    availability_zone = var.subnet_3_az
    tags = {
        Name = "webSub3"
    }
}
