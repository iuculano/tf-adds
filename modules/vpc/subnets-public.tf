/*
  Be mindful of the variables that are being passed in.

  These are expected to contain the same number of elements.
    availability_zones
    public_subnets
    application_subnets
    database_subnets
    serverless_subnets
*/


#-------------------------------------------------------------------------------
# Public subnets - inbound & outbound connectivity to the internet
#                  This subnet gives instances public IPs by default
#-------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  
  tags = {
    Name        = "AZ${count.index + 1} Public"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  

  tags = {
    Name        = "${var.environment} IGW"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "IGW Public routing table"
    Environment = var.environment
  }
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
