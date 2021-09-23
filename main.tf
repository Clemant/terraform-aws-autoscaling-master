### Provider definition

provider "aws" {
  region = "${var.aws_region}"
}

### Module Main

module "discovery" {
  source              = "github.com/Lowess/terraform-aws-discovery"
  aws_region          = var.aws_region
  vpc_name            = var.vpc_name
}

output "vpcid" {
  value = module.discovery.vpc_id
}

output "subnet_public" {
    value = module.discovery.public_subnets
}



### Step 3: Creation du load balancer
resource "aws_lb" "alb_public" {
  name               = "loadBalancing"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group_http.id ]
  subnets            = module.discovery.public_subnets

  tags = {
    Name = "load_balancing_dev"
  }
}

### Step 4: Creation d'un load balancer target group

resource "aws_lb_target_group" "lb_target_group" {
  name     = "lbTargetGroup"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.discovery.vpc_id
}

### Step 5: Creation du listener
resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.alb_public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}







