resource "aws_internet_gateway" "webIG" {
    vpc_id = "${aws_vpc.webVPC.id}"
    tags = {
        Name = "webIG"
    }
}

resource "aws_route_table" "webRoute" {
    vpc_id = "${aws_vpc.webVPC.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.webIG.id}" 
    }
    
    tags  = {
        Name = "webRoute"
    }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.webSub1.id}"
    route_table_id = "${aws_route_table.webRoute.id}"
}

resource "aws_route_table_association" "prod-crta-public-subnet-2"{
    subnet_id = "${aws_subnet.webSub2.id}"
    route_table_id = "${aws_route_table.webRoute.id}"
}

resource "aws_route_table_association" "prod-crta-public-subnet-3"{
    subnet_id = "${aws_subnet.webSub3.id}"
    route_table_id = "${aws_route_table.webRoute.id}"
}

resource "aws_security_group" "webSG" {
    vpc_id = "${aws_vpc.webVPC.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "webSG"
    }
}

/*variable "AMI" {
    type = "map"
    
    default = {
        eu-west-2 = "ami-03dea29b0216a1e03"
        us-east-1 = "ami-0c2a1acae6667e438"
        eu-central-1 = "ami-02ccbe126fe6afe82"
    }
}*/