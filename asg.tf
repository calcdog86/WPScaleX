resource "aws_launch_template" "TemplateForAutoScaling" {
  name_prefix   = "TemplateForAutoScaling"
  image_id      = "ami-099da3ad959447ffa" # Amazon Linux 2
  instance_type = "t3.micro"

  network_interfaces {
    security_groups = [aws_security_group.webSG.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable php8.0
    yum install -y php php-mysqlnd httpd mariadb

    systemctl enable httpd
    systemctl start httpd

    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz

    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${aws_db_instance.wordpressDB.db_name}/" wp-config.php
    sed -i "s/username_here/admin/" wp-config.php
    sed -i "s/password_here/admin1234}/" wp-config.php
    sed -i "s/localhost/${aws_db_instance.wordpressDB.address}/" wp-config.php

    chown -R apache:apache /var/www/html
    chmod -R 755 /var/www/html

    systemctl restart httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web-Server"
    }
  }
}

resource "aws_autoscaling_group" "webScale" {
    desired_capacity     = 3
    max_size            = 10
    min_size            = 1
    vpc_zone_identifier = [aws_subnet.webSub1.id, aws_subnet.webSub2.id, aws_subnet.webSub3.id]

    launch_template {
        id      = aws_launch_template.TemplateForAutoScaling.id
        version = "$Latest"
    }

    target_group_arns = [aws_lb_target_group.webTG.arn]

    tag {
        key                 = "Name"
        value               = "Web-Server"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "scale_out" {
    name                   = "scale-out"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown              = 60
    autoscaling_group_name = aws_autoscaling_group.webScale.name
  }