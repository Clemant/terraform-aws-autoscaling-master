
data "aws_ami" "get_ami" {
  most_recent = true
  name_regex = "amzn2-ami-hvm-2.0.20210813.1-x86_64-gp2"
  owners = ["amazon"]
}

## Step test:
output "tt" {
  value = data.aws_ami.get_ami.id
}



### Step: 
resource "aws_launch_template" "launch_template" {
  name = "my_launch_template"
  image_id = data.aws_ami.get_ami.id
  key_name = "deployer-key"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group_http_autoscaling.id ]
  user_data = filebase64("script.sh")
}

resource "aws_autoscaling_group" "autoscale" {
  name = "autoscale"
  max_size             = 2
  min_size             = 1
  target_group_arns = [aws_lb_target_group.lb_target_group.arn]
  vpc_zone_identifier = module.discovery.public_subnets
   launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }

}