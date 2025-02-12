resource "aws_lb_target_group" "webTG" {
    name        = "webTG"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.webVPC.id
}

resource "aws_lb" "webBalancer" {
    name                = "webBalancer"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.webSG.id]
    subnets             = [aws_subnet.webSub1.id, aws_subnet.webSub2.id, aws_subnet.webSub3.id]

    tags = {
        Name = "webBalancer"
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.webBalancer.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.webTG.arn
    }
}