### Step 1: Creation d'un security Group
resource "aws_security_group" "security_group_http" {
  name        = "Http security"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.discovery.vpc_id
  tags = {
    Name = "allow_http"
  }
}


### Step 2: Creation des règles de sécurité

resource "aws_security_group_rule" "security_group_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       =  ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_http.id
}

### Step 2.1: Creation des règles de sécurité

resource "aws_security_group_rule" "security_group_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_http.id
}









### Step 6: Creation du SecurityGroup

resource "aws_security_group" "security_group_http_autoscaling" {
  name        = "AutoScaling Security"
  description = "Allow inbound traffic"
  vpc_id      = module.discovery.vpc_id
  tags = {
    Name = "allow_autoscaling_http"
  }
}

### Step 6: Creation des règles de sécurité group (ingress)
resource "aws_security_group_rule" "security_group_autoscaling_ingress" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = aws_security_group.security_group_http.id
  security_group_id = aws_security_group.security_group_http_autoscaling.id
}

### Step 6.1: Creation des règles de sécurité (egress)

resource "aws_security_group_rule" "security_group_autoscalingegress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_http_autoscaling.id
}
