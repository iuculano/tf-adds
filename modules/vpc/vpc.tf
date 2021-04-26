#-------------------------------------------------------------------------------
# Main VPC setup
#-------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block


  tags = {
    Name       = "${var.environment} VPC"
    Enviroment = var.environment
  }
}

# !! Unless you have a very good reason, you probably don't want to ouch this !!
# This isn't even really a resource, per se - instead this will cause Terraform
# to take ownership of the VPC's default security group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
