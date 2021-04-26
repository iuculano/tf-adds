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
# Private subnets - these instances can connect to the Internet using the NAT 
#                   gateway, but the Internet cannot establish connections back
#-------------------------------------------------------------------------------
resource "aws_subnet" "application" {
  count             = length(var.application_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.application_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

    
  tags = {
    Name        = "AZ${count.index + 1} Application"
    Environment = var.environment
  }
}

resource "aws_subnet" "database" {
  count             = length(var.database_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

    
  tags = {
    Name        = "AZ${count.index + 1} Database"
    Environment = var.environment
  }
}

resource "aws_subnet" "serverless" {
  count             = length(var.serverless_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.serverless_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

    
  tags = {
    Name        = "AZ${count.index + 1} Serverless"
    Environment = var.environment
  }
}

# NAT gateways reside in the public subnets, they need a public IP
resource "aws_eip" "this" {
  count = length(var.public_subnets)

  vpc   = true

  tags = {
    Name        = "AZ${count.index + 1} NAT EIP"
    Environment = var.environment
  }
}

# Deploy a NAT Gateway per AZ
resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnets)

  allocation_id = element(aws_eip.this.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "AZ${count.index + 1} NGW"
    Environment = var.environment
  }

  # As per TF docs, make the NAT gateway depend on the IGW
  depends_on = [aws_internet_gateway.this]
}

# Each subnet needs its own route table
resource "aws_route_table" "private" {
  count  = length(concat(var.application_subnets, var.database_subnets, var.serverless_subnets))

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "NAT routing table"
    Environment = var.environment
  }
}

# And each route table needs a route defined
resource "aws_route" "nat" {
  count = length(concat(var.application_subnets, var.database_subnets, var.serverless_subnets))

  # This modulo is pretty tricky
  # Say we're targeting 2 AZ's, that's 2 application subnets, 2 database subnets, 2 serverless subnets - 6 total

  # We need to assign 2 NAT gateways to this list of 6, so a modulo can be used to wrap around.
  # count happens to be 0 based, so: the index of count % max AZs

  # Application subnets:
  # 0 % 2 = 0... natgw[0]
  # 1 % 2 = 1... natgw[1]

  # Database subnets:
  # 2 % 2 = 0... natgw[0]
  # 3 % 2 = 1... natgw[1]

  # Serverless subnets:
  # 4 % 2 = 0... natgw[0]
  # 5 % 2 = 1... natgw[1]
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index % length(var.public_subnets))
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = length(concat(var.application_subnets, var.database_subnets, var.serverless_subnets))

  subnet_id      = element(concat(aws_subnet.application.*.id, aws_subnet.database.*.id, aws_subnet.serverless.*.id), count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
