resource "aws_db_subnet_group" "rdsSub" {
    name = "rdsSub"
    subnet_ids = [aws_subnet.webSub1.id, aws_subnet.webSub2.id, aws_subnet.webSub3.id]

    tags = {
        Name = "rdsSub"
    }
}

resource "aws_db_instance" "wordpressDB" {
    allocated_storage    = 10
    engine              = "mysql"
    instance_class      = "db.t3.micro"
    db_subnet_group_name = aws_db_subnet_group.rdsSub.name
    publicly_accessible = false
    skip_final_snapshot = true
    username           = "admin"
    password           = "admin1234"
    db_name = "wordpressDB"
}