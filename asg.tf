resource "aws_launch_template" "TemplateForAutoScaling" {
  name_prefix   = "TemplateForAutoScaling"
  image_id      = "ami-099da3ad959447ffa" # Amazon Linux 2
  instance_type = "t2.micro"

  network_interfaces {
    security_groups = [aws_security_group.webSG.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd php php-mysqli mariadb105 wget php-fpm php-json php-devel php-zip php-xml php-mbstring php-intl php-curl php-bcmath ghostscript

    sed -i "s/AllowOverride None/AllowOverride all/" /etc/httpd/conf/httpd.conf
    sed -i "s/Options Indexes FollowSymLinks/Options all/" /etc/httpd/conf/httpd.conf
    sed -i "s/Options None/Options all/" /etc/httpd/conf/httpd.conf

    systemctl enable httpd
    systemctl start httpd

    usermod -a -G apache ec2-user
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;

    wget https://github.com/WordPress/WordPress/archive/master.zip
    unzip master -d /tmp/WordPress_Temp
    mkdir -p /var/www/html/wordpress
    cp -paf /tmp/WordPress_Temp/WordPress-master/* /var/www/html/wordpress
    rm -rf /tmp/WordPress_Temp
    rm -f master

    cd /var/www/html/wordpress
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${aws_db_instance.wordpressDB.db_name}/" wp-config.php
    sed -i "s/username_here/admin/" wp-config.php
    sed -i "s/password_here/admin1234/" wp-config.php
    sed -i "s/localhost/${aws_db_instance.wordpressDB.address}/" wp-config.php

    
    # BEGIN WordPress
    #echo "# BEGIN WordPress" > /var/www/html/wordpress/.htaccess
    #echo "RewriteEngine On" >> /var/www/html/wordpress/.htaccess
    #echo "RewriteBase /" >> /var/www/html/wordpress/.htaccess
    #echo "RewriteRule ^index\\.php$ - [L]" >> /var/www/html/wordpress/.htaccess
    #echo "RewriteCond %\{REQUEST_FILENAME\} !-f" >> /var/www/html/wordpress/.htaccess
    #echo "RewriteCond %\{REQUEST_FILENAME\} !-d" >> /var/www/html/wordpress/.htaccess
    #echo "RewriteRule . /index.php [L]" >> /var/www/html/wordpress/.htaccess
    #echo "# END WordPress" >> /var/www/html/wordpress/.htaccess
    # END WordPress

    chown -R apache:apache /var/www/html
    chmod -R 755 /var/www/html
    chmod -R 755 /var/www/html/wordpress
    chmod -R 775 /var/www/html/wordpress/wp-content/uploads

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