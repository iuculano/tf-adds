data "aws_ami" "server_core_2019" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Core-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # Amazon
}


#-------------------------------------------------------------------------------
# Baseline permissions for SSM to function
# This MUST be attached to whatever instance you want managed by SSM
#-------------------------------------------------------------------------------
resource "aws_iam_role" "this" {
  assume_role_policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": 
  {
    "Effect"   : "Allow",      
    "Action"   : "sts:AssumeRole",
    "Principal": { "Service": "ec2.amazonaws.com" }
  }
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  role = aws_iam_role.this.name
}

#-------------------------------------------------------------------------------
# KMS key pair for the EC2 instances
#-------------------------------------------------------------------------------
resource "aws_key_pair" "this" {
  public_key = var.public_key
}

#-------------------------------------------------------------------------------
# The backing instances for our domain
#-------------------------------------------------------------------------------
resource "aws_instance" "this" {
  count                = 1 # Just hardcoded to 1 for now

  ami                  = (var.ami_id == "") ? data.aws_ami.server_core_2019.id : var.ami_id
  instance_type        = var.launch_instance_type
  subnet_id            = element(var.launch_subnet_ids, count.index % length(var.launch_subnet_ids))
  iam_instance_profile = aws_iam_instance_profile.this.name
  key_name             = aws_key_pair.this.key_name
}
